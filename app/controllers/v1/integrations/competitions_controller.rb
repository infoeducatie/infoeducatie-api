module V1
  module Integrations
    class CompetitionsController < BaseController
      VALID_YEAR_RANGE = (1900..9999).freeze

      before_action -> {
        require_api_scope!(ApiCredential::COMPETITIONS_READ_SCOPE)
      }

      def index
        competitions = apply_year_filter!(
          Edition.order(year: :desc, id: :desc)
        )
        return unless competitions

        competitions = competitions.to_a
        competition_ids = competitions.map(&:id)
        participant_counts = Contestant
          .where(edition_id: competition_ids)
          .group(:edition_id)
          .count
        project_counts = Project
          .where(edition_id: competition_ids)
          .group(:edition_id)
          .count
        approved_project_counts = Project
          .approved
          .where(edition_id: competition_ids)
          .group(:edition_id)
          .count

        render json: {
          data: competitions.map do |competition|
            ::Integrations::CompetitionSerializer.new(
              competition,
              participant_count: participant_counts.fetch(competition.id, 0),
              project_count: project_counts.fetch(competition.id, 0),
              approved_project_count: approved_project_counts.fetch(competition.id, 0)
            ).as_json
          end,
          meta: {
            count: competitions.length,
            generated_at: Time.current.iso8601(3)
          }
        }
      end

      private

      def apply_year_filter!(scope)
        return scope if params[:year].blank?

        year = Integer(params[:year], 10)
        return scope.where(year: year) if VALID_YEAR_RANGE.cover?(year)

        render_invalid_year
        nil
      rescue ArgumentError, TypeError, RangeError
        render_invalid_year
        nil
      end

      def render_invalid_year
        render_api_error(
          code: "invalid_year",
          message: "year must be a four-digit integer.",
          status: :bad_request
        )
      end
    end
  end
end
