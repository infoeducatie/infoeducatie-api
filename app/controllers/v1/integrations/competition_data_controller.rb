module V1
  module Integrations
    class CompetitionDataController < BaseController
      ALLOWED_INCLUDES = %w[personal_data].freeze
      MAX_DATABASE_ID = 2_147_483_647
      VALID_YEAR_RANGE = (1900..9999).freeze

      before_action -> {
        require_api_scope!(ApiCredential::COMPETITION_DATA_READ_SCOPE)
      }

      def show
        competition = find_competition
        return unless competition

        requested_includes = parse_includes
        return unless requested_includes
        return unless authorize_personal_data!(requested_includes)

        participants = competition.contestants
          .includes(:user, :projects)
          .order(:id)
          .to_a
        projects = competition.projects
          .includes(:category, :contestants, :screenshots)
          .order(:id)
          .to_a

        if requested_includes.include?("personal_data")
          Rails.logger.info(
            "Integration API personal data export " \
            "credential_id=#{current_api_credential.id} " \
            "competition_id=#{competition.id} request_id=#{request.request_id}"
          )
        end

        render json: ::Integrations::CompetitionDatasetSerializer.new(
          competition: competition,
          participants: participants,
          projects: projects,
          include_personal_data: requested_includes.include?("personal_data")
        ).as_json
      end

      private

      def find_competition
        selectors = {
          competition_id: params[:competition_id].presence,
          year: params[:year].presence
        }.compact

        if selectors.length != 1
          render_api_error(
            code: "invalid_selector",
            message: "Provide exactly one of competition_id or year.",
            status: :bad_request
          )
          return
        end

        if selectors.key?(:competition_id)
          find_by_id(selectors[:competition_id])
        else
          find_by_year(selectors[:year])
        end
      end

      def find_by_id(value)
        competition_id = Integer(value, 10)
        unless competition_id.between?(1, MAX_DATABASE_ID)
          render_invalid_competition_id
          return
        end

        competition = Edition.find_by(id: competition_id)
        return competition if competition

        render_competition_not_found
        nil
      rescue ArgumentError, TypeError, RangeError
        render_invalid_competition_id
        nil
      end

      def render_invalid_competition_id
        render_api_error(
          code: "invalid_competition_id",
          message: "competition_id must be a positive integer.",
          status: :bad_request
        )
      end

      def find_by_year(value)
        year = Integer(value, 10)
        unless VALID_YEAR_RANGE.cover?(year)
          render_invalid_year
          return
        end

        competitions = Edition.where(year: year).order(:id).to_a
        return competitions.first if competitions.one?

        if competitions.many?
          render_api_error(
            code: "ambiguous_year",
            message: "More than one competition exists for this year. Use competition_id.",
            status: :conflict,
            details: {
              competitions: competitions.map { |competition|
                {id: competition.id, name: competition.name, year: competition.year}
              }
            }
          )
          return
        end

        render_competition_not_found
        nil
      rescue ArgumentError, TypeError, RangeError
        render_invalid_year
        nil
      end

      def parse_includes
        requested = params[:include].to_s
          .split(",")
          .map(&:strip)
          .reject(&:blank?)
          .uniq
        unsupported = requested - ALLOWED_INCLUDES
        return requested if unsupported.empty?

        render_api_error(
          code: "unsupported_include",
          message: "One or more requested include values are not supported.",
          status: :bad_request,
          details: {
            unsupported: unsupported,
            allowed: ALLOWED_INCLUDES
          }
        )
        nil
      end

      def authorize_personal_data!(requested_includes)
        return true unless requested_includes.include?("personal_data")
        return true if current_api_credential.allows?(
          ApiCredential::PARTICIPANT_PERSONAL_DATA_READ_SCOPE
        )

        require_api_scope!(
          ApiCredential::PARTICIPANT_PERSONAL_DATA_READ_SCOPE
        )
        false
      end

      def render_invalid_year
        render_api_error(
          code: "invalid_year",
          message: "year must be a four-digit integer.",
          status: :bad_request
        )
      end

      def render_competition_not_found
        render_api_error(
          code: "competition_not_found",
          message: "No competition matches the requested selector.",
          status: :not_found
        )
      end
    end
  end
end
