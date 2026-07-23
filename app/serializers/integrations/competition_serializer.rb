module Integrations
  class CompetitionSerializer
    def initialize(
      competition,
      participant_count:,
      project_count:,
      approved_project_count:
    )
      @competition = competition
      @participant_count = participant_count
      @project_count = project_count
      @approved_project_count = approved_project_count
    end

    def as_json(*)
      {
        id: competition.id,
        year: competition.year,
        name: competition.name,
        motto: competition.motto,
        published: competition.published,
        current: competition.current,
        show_results: competition.show_results,
        camp: {
          starts_on: iso_date(competition.camp_start_date),
          ends_on: iso_date(competition.camp_end_date)
        },
        registration: {
          opens_at: iso_time(competition.registration_start_date),
          closes_at: iso_time(competition.registration_end_date)
        },
        travel_data_deadline: iso_date(competition.travel_data_deadline),
        counts: {
          participants: participant_count,
          projects: project_count,
          approved_projects: approved_project_count
        }
      }
    end

    private

    attr_reader :competition,
      :participant_count,
      :project_count,
      :approved_project_count

    def iso_date(value)
      value&.iso8601
    end

    def iso_time(value)
      value&.iso8601(3)
    end
  end
end
