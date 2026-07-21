# syntax=docker/dockerfile:1

ARG RUBY_VERSION=4.0.6
FROM ruby:${RUBY_VERSION}-slim AS base

ARG BUNDLE_WITHOUT=development:test
ENV APP_HOME=/app \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
    RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

WORKDIR ${APP_HOME}

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      imagemagick \
      libpq5 && \
    rm -rf /var/lib/apt/lists/*

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf /root/.bundle "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM base

COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build ${APP_HOME} ${APP_HOME}

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p log tmp/pids tmp/cache tmp/uploads && \
    chown -R rails:rails log tmp

USER 1000:1000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD ruby -rnet/http -e "exit(Net::HTTP.get_response(URI('http://127.0.0.1:3000/up')).is_a?(Net::HTTPSuccess) ? 0 : 1)"

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
