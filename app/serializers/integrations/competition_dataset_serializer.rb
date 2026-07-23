module Integrations
  class CompetitionDatasetSerializer
    PROJECT_STATUSES = {
      Project::STATUS_REJECTED => "rejected",
      Project::STATUS_WAITING => "waiting",
      Project::STATUS_APPROVED => "approved"
    }.freeze

    SEXES = {
      1 => "male",
      2 => "female",
      3 => "undisclosed"
    }.freeze

    def initialize(
      competition:,
      participants:,
      projects:,
      include_personal_data:
    )
      @competition = competition
      @participants = participants
      @projects = projects
      @include_personal_data = include_personal_data
    end

    def as_json(*)
      {
        data: {
          competition: competition_payload,
          participants: participants.map { |participant|
            participant_payload(participant)
          },
          projects: projects.map { |project| project_payload(project) }
        },
        meta: {
          generated_at: Time.current.iso8601(3),
          includes: include_personal_data ? ["personal_data"] : [],
          counts: {
            participants: participants.length,
            projects: projects.length
          }
        }
      }
    end

    private

    attr_reader :competition, :participants, :projects, :include_personal_data

    def competition_payload
      CompetitionSerializer.new(
        competition,
        participant_count: participants.length,
        project_count: projects.length,
        approved_project_count: projects.count {
          |project| project.status == Project::STATUS_APPROVED && project.finished?
        }
      ).as_json
    end

    def participant_payload(participant)
      payload = {
        id: participant.id,
        user_id: participant.user_id,
        first_name: participant.user.first_name,
        last_name: participant.user.last_name,
        name: participant.name,
        grade: participant.grade,
        official: participant.official,
        present_in_camp: participant.present_in_camp,
        paying_camp_accommodation: participant.paying_camp_accommodation,
        school: {
          name: participant.school_name,
          city: participant.school_city,
          county: participant.school_county,
          country: participant.school_country
        },
        mentoring_teacher: {
          first_name: participant.mentoring_teacher_first_name,
          last_name: participant.mentoring_teacher_last_name,
          name: participant.mentoring_teacher_name
        },
        project_ids: participant.projects.map(&:id).sort,
        created_at: iso_time(participant.created_at),
        updated_at: iso_time(participant.updated_at)
      }

      payload[:personal_data] = participant_personal_data(participant) if include_personal_data
      payload
    end

    def participant_personal_data(participant)
      {
        email: participant.user.email,
        phone_number: participant.phone_number,
        date_of_birth: participant.date_of_birth&.iso8601,
        sex: {
          code: participant.sex,
          name: SEXES[participant.sex]
        },
        address: {
          street: participant.address,
          city: participant.city,
          county: participant.county,
          country: participant.country,
          postal_code: participant.zip_code
        },
        identity_document: {
          national_id: participant.cnp,
          type: participant.id_card_type,
          number: participant.id_card_number
        }
      }
    end

    def project_payload(project)
      {
        id: project.id,
        title: project.title,
        description: project.description,
        technical_description: project.technical_description,
        system_requirements: project.system_requirements,
        category: {
          id: project.category_id,
          name: project.category&.name
        },
        status: {
          code: project.status,
          name: PROJECT_STATUSES[project.status] || "unknown"
        },
        finished: project.finished,
        open_source: project.open_source,
        source_url: project.source_url,
        homepage: project.homepage,
        closed_source_reason: project.closed_source_reason,
        github_username: project.github_username,
        score: project.score,
        extra_score: project.extra_score,
        total_score: project.total_score,
        prize: project.prize,
        comments_count: project.comments_count,
        discourse_topic_id: project.topic_id,
        discourse_url: project.discourse_url,
        participant_ids: project.contestants.map(&:id).sort,
        screenshots: project.screenshots.map { |screenshot|
          {id: screenshot.id, url: screenshot.screenshot.url}
        },
        created_at: iso_time(project.created_at),
        updated_at: iso_time(project.updated_at)
      }
    end

    def iso_time(value)
      value&.iso8601(3)
    end
  end
end
