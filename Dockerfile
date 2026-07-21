FROM ruby:2.4

RUN sed -i \
      -e 's|^# deb http://snapshot.debian.org|deb http://snapshot.debian.org|' \
      -e 's|^deb http://deb.debian.org|# deb http://deb.debian.org|' \
      -e 's|^deb http://security.debian.org|# deb http://security.debian.org|' \
      /etc/apt/sources.list \
    && printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99snapshot \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      libxml2-dev \
      libxslt1-dev \
      nodejs \
    && rm -rf /var/lib/apt/lists/*

ARG RAILS_ENV=production
ENV APP_HOME=/myapp

RUN mkdir $APP_HOME/
WORKDIR $APP_HOME/

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME/
RUN bundle exec rake assets:precompile
