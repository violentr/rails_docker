ARG RUBY_VERSION=2.6.0
FROM ruby:$RUBY_VERSION

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' 11 > /etc/apt/sources.list.d/pgdg.list

COPY .dockerdev/Aptfile /tmp/Aptfile

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    postgresql-client-11 \
    nodejs \
    yarn=1.17.3-1 \
    $(cat /tmp/Aptfile | xargs)

ENV APP_PATH=/app/
RUN mkdir $APP_PATH

ENV GEM_HOME=/bundle
ENV BUNDLE_PATH $GEM_HOME

WORKDIR $APP_PATH
COPY Gemfile Gemfile.lock $APP_PATH

RUN gem install bundler --version=2.0.2

RUN bundle install --jobs=2

COPY package.json yarn.lock $APP_PATH
RUN yarn install

COPY . $APP_PATH
RUN /app/check_dependencies.sh

EXPOSE 3000

CMD ["bundle","exec","rails", "s", "-b", "0.0.0.0"]
