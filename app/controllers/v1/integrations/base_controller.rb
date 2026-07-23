module V1
  module Integrations
    class BaseController < ApiController
      RATE_LIMIT = [ENV.fetch("INTEGRATION_API_RATE_LIMIT", "300").to_i, 1].max

      before_action :disable_response_caching
      before_action :require_secure_transport
      before_action :load_api_credential

      rate_limit(
        to: RATE_LIMIT,
        within: 1.minute,
        by: -> {
          if current_api_credential
            "credential:#{current_api_credential.id}"
          else
            "ip:#{request.remote_ip}"
          end
        },
        name: "credential-or-ip",
        scope: "integration-api",
        with: -> {
          response.headers["Retry-After"] = "60"
          render_api_error(
            code: "rate_limit_exceeded",
            message: "Too many requests. Retry after 60 seconds.",
            status: :too_many_requests
          )
        }
      )

      before_action :require_api_credential!
      after_action :record_api_credential_use

      private

      attr_reader :current_api_credential

      def require_secure_transport
        return unless Rails.env.production?
        return if request.ssl?

        render_api_error(
          code: "https_required",
          message: "API keys may only be sent over HTTPS.",
          status: :bad_request
        )
      end

      def load_api_credential
        @current_api_credential = ApiCredential.authenticate(bearer_token)
      end

      def require_api_credential!
        if current_api_credential
          log_authenticated_request
          return
        end

        response.headers["WWW-Authenticate"] =
          'Bearer realm="InfoEducatie integrations", error="invalid_token"'
        render_api_error(
          code: "unauthorized",
          message: "A valid API key is required.",
          status: :unauthorized
        )
      end

      def log_authenticated_request
        Rails.logger.info(
          "Integration API request credential_id=#{current_api_credential.id} " \
          "scope_count=#{current_api_credential.scopes.length} " \
          "request_id=#{request.request_id}"
        )
      end

      def require_api_scope!(scope)
        return if current_api_credential&.allows?(scope)

        response.headers["WWW-Authenticate"] =
          "Bearer realm=\"InfoEducatie integrations\", " \
          "error=\"insufficient_scope\", scope=\"#{scope}\""
        render_api_error(
          code: "insufficient_scope",
          message: "This API key does not grant the required scope.",
          status: :forbidden,
          details: {required_scope: scope}
        )
      end

      def render_api_error(code:, message:, status:, details: nil)
        payload = {
          error: {
            code: code,
            message: message,
            request_id: request.request_id
          }
        }
        payload[:error].merge!(details) if details
        render json: payload, status: status
      end

      def disable_response_caching
        response.headers["Cache-Control"] = "private, no-store, max-age=0"
        response.headers["Pragma"] = "no-cache"
      end

      def bearer_token
        authorization = request.headers["Authorization"].to_s
        match = /\ABearer ([^\s]+)\z/i.match(authorization)
        match&.captures&.first
      end

      def record_api_credential_use
        return unless current_api_credential
        return if response.status == 429

        current_api_credential.record_use!(ip: request.remote_ip)
      rescue ActiveRecord::ActiveRecordError => error
        Rails.logger.warn(
          "Integration API usage audit failed " \
          "credential_id=#{current_api_credential.id} " \
          "error=#{error.class} request_id=#{request.request_id}"
        )
      end
    end
  end
end
