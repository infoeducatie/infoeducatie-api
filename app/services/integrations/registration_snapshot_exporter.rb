require "digest"
require "fileutils"
require "json"
require "pathname"

module Integrations
  class RegistrationSnapshotExporter
    SNAPSHOT_FILE_NAME = "registration-snapshot.json"
    SEXES = {
      1 => "male",
      2 => "female",
      3 => "preferNotToSay"
    }.freeze

    def initialize(output_directory:, snapshot_id:, include_personal_data: true)
      destination = Pathname.new(output_directory)
      @output_directory_was_absolute = destination.absolute?
      @output_directory = destination.expand_path
      @snapshot_id = snapshot_id.to_s.strip
      @include_personal_data = include_personal_data
    end

    def export!
      created_output = false
      validate_destination!
      FileUtils.mkdir_p(output_directory)
      created_output = true
      payload = {
        snapshotId: snapshot_id,
        capturedAt: Time.current.iso8601(3),
        includesAllEditions: true,
        editions: Edition.order(:year, :id).map { |edition| edition_payload(edition) }
      }
      snapshot_path = output_directory.join(SNAPSHOT_FILE_NAME)
      File.write(snapshot_path, JSON.pretty_generate(payload))
      snapshot_path
    rescue
      FileUtils.rm_rf(output_directory) if created_output && output_directory.exist?
      raise
    end

    private

    attr_reader :output_directory, :snapshot_id, :include_personal_data,
      :output_directory_was_absolute

    def validate_destination!
      raise ArgumentError, "snapshot_id is required" if snapshot_id.blank?
      raise ArgumentError, "output_directory must be absolute" unless output_directory_was_absolute
      raise ArgumentError, "output_directory already exists" if output_directory.exist?
    end

    def edition_payload(edition)
      contestants = edition.contestants.includes(:user).order(:id).to_a
      teachers = edition.teachers.includes(:user).order(:id).to_a
      projects = edition.projects
        .includes(:category, :colaborators, :contestants, :screenshots)
        .order(:id)
        .to_a
      categories = projects.map(&:category).compact.uniq(&:id).sort_by { |category|
        [category.name.to_s.downcase, category.id]
      }
      slugs = category_slugs(categories)

      {
        id: edition.id,
        year: edition.year,
        name: edition.name,
        archived: !edition.current?,
        categories: categories.each_with_index.map { |category, index|
          {
            id: category.id,
            name: category.name,
            slug: slugs.fetch(category.id),
            displayOrder: index + 1
          }
        },
        contestants: contestants.map { |contestant| contestant_payload(contestant) },
        teachers: teachers.map { |teacher| teacher_payload(teacher) },
        projects: projects.map { |project| project_payload(project) }
      }
    end

    def category_slugs(categories)
      used = {}
      categories.to_h do |category|
        base = category.name.to_s.parameterize.presence || "category-#{category.id}"
        slug = used.key?(base) ? "#{base}-#{category.id}" : base
        used[slug] = true
        [category.id, slug]
      end
    end

    def contestant_payload(contestant)
      payload = {
        id: contestant.id,
        firstName: contestant.user.first_name,
        lastName: contestant.user.last_name,
        grade: contestant.grade,
        school: contestant.school_name,
        schoolCity: contestant.school_city,
        schoolCounty: contestant.school_county,
        schoolCountry: contestant.school_country,
        mentoringTeacher: [
          contestant.mentoring_teacher_first_name,
          contestant.mentoring_teacher_last_name
        ].compact.join(" ").presence,
        sex: SEXES[contestant.sex],
        dateOfBirth: contestant.date_of_birth&.iso8601,
        isOfficial: !!contestant.official,
        isPresentInCamp: !!contestant.present_in_camp,
        isAccommodationPaying: !!contestant.paying_camp_accommodation,
        privateData: nil,
        createdAt: iso_time(contestant.created_at),
        updatedAt: iso_time(contestant.updated_at)
      }
      if include_personal_data
        payload[:privateData] = {
          email: contestant.user.email,
          phoneNumber: contestant.phone_number,
          city: contestant.city,
          county: contestant.county,
          country: contestant.country,
          street: contestant.address,
          postalCode: contestant.zip_code,
          nationalId: contestant.cnp,
          identityDocumentType: contestant.id_card_type,
          identityDocumentSeries: nil,
          identityDocumentNumber: contestant.id_card_number
        }
      end
      payload
    end

    def teacher_payload(teacher)
      {
        id: teacher.id,
        firstName: teacher.user.first_name,
        lastName: teacher.user.last_name,
        sex: SEXES[teacher.sex],
        phoneNumber: teacher.phone_number,
        school: teacher.school_name,
        schoolCity: teacher.school_city,
        schoolCounty: teacher.school_county,
        schoolCountry: teacher.school_country,
        createdAt: iso_time(teacher.created_at),
        updatedAt: iso_time(teacher.updated_at)
      }
    end

    def project_payload(project)
      state = project_state(project)
      screenshots = project.screenshots.sort_by { |screenshot|
        [screenshot.created_at || Time.at(0), screenshot.id]
      }
      {
        id: project.id,
        categoryId: project.category_id,
        title: project.title.to_s,
        description: project.description,
        technicalDescription: project.technical_description,
        systemRequirements: project.system_requirements,
        sourceUrl: project.source_url,
        isOpenSource: project.open_source,
        closedSourceReason: project.closed_source_reason,
        gitHubUsername: project.github_username,
        youTubeUrl: nil,
        homepage: project.homepage,
        discourseUrl: project.discourse_url,
        status: state.fetch(:status),
        moderationReason: state[:moderation_reason],
        isDisabled: project.status == Project::STATUS_REJECTED,
        isInOpen: !project.extra_score.to_d.zero?,
        projectScore: project.score,
        openScore: project.extra_score.to_d.nonzero? ? project.extra_score : nil,
        finalPrize: project.prize.presence,
        createdAt: iso_time(project.created_at),
        updatedAt: iso_time(project.updated_at),
        submittedAt: state[:submitted_at],
        moderatedAt: state[:moderated_at],
        contestantIds: ordered_contestant_ids(project),
        screenshots: screenshots.each_with_index.map { |screenshot, index|
          screenshot_payload(screenshot, index + 1)
        }
      }
    end

    def project_state(project)
      return {status: "draft", submitted_at: nil, moderated_at: nil} unless project.finished?

      submitted_at = iso_time(project.updated_at)
      case project.status
      when Project::STATUS_APPROVED
        {status: "approved", submitted_at: submitted_at, moderated_at: submitted_at}
      when Project::STATUS_REJECTED
        {
          status: "rejected",
          moderation_reason: "Rejected in the legacy registration administration.",
          submitted_at: submitted_at,
          moderated_at: submitted_at
        }
      else
        {status: "submitted", submitted_at: submitted_at, moderated_at: nil}
      end
    end

    def ordered_contestant_ids(project)
      project.colaborators.sort_by { |relationship|
        [relationship.created_at || Time.at(0), relationship.id]
      }.map(&:contestant_id)
    end

    def screenshot_payload(screenshot, display_order)
      file = screenshot.screenshot.file
      raise "Screenshot #{screenshot.id} has no stored file" unless file

      bytes = file.read
      raise "Screenshot #{screenshot.id} is empty" if bytes.blank?

      original_name = File.basename(screenshot.filename.to_s.presence || "screenshot-#{screenshot.id}")
      relative_path = Pathname.new("screenshots").join(screenshot.id.to_s, original_name)
      destination = output_directory.join(relative_path)
      FileUtils.mkdir_p(destination.dirname)
      File.binwrite(destination, bytes)
      {
        id: screenshot.id,
        sourcePath: relative_path.to_s,
        originalFileName: original_name,
        sha256: Digest::SHA256.hexdigest(bytes).upcase,
        displayOrder: display_order
      }
    end

    def iso_time(value)
      value&.iso8601(3)
    end
  end
end
