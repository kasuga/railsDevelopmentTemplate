FROM ruby:2.7.0-alpine as builder

ENV RAILS_ENV production
WORKDIR /builder

# Install build packages
RUN apk add --no-cache \
    yarn \
    postgresql-dev \
    tzdata \
    ruby-dev \
    build-base

# Install gems
RUN gem update --system
RUN gem update bundler

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install --without development:test -j4

ENV SECRET_KEY_BASE=dummy
COPY . ./
RUN bin/rails asserts:precompile

FROM ruby:2.7.0-alpine

ENV RAILS_ENV production
WORKDIR /app

RUN apk add --no-chache \
        nodejs \
        postgresql-dev \
        tzdata

COPY . ./

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /builder/public/asserts ./public/asserts
COPY --from=builder /buider/public/packs ./public/packs

ENV PORT 3000
EXPOSE 3000

CMD bin/rails server -p $PORT -e $RAILS_ENV
