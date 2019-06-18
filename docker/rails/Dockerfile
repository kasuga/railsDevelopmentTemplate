FROM ruby:2.6.3-alpine as builder

FROM ruby:2.6.3-alpine

RUN apt-get update -qq && \
        apt-get install -y build-base \
        libpq-dev \
        nodejs \
        postgresql-dev \
        tzdata

# make work directory
RUN mkdir /app
ENV APP_ROOT /app
WORKDIR $APP_ROOT

# add Gem & insall
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install --without development:test -j4
COPY . ./

