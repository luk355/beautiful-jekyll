FROM alpine:latest

MAINTAINER Lukas Behal <luk355@gmail.com>
#inspired by https://blog.codeship.com/build-minimal-docker-container-ruby-apps/

ENV BUILD_PACKAGES bash curl-dev ruby-dev libffi-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN mkdir /usr/app
WORKDIR /usr/app

COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/

# Install all required GEMs
RUN bundle install

# copy app to the Docker container
COPY . /usr/app

# Make port 4000 available to the world outside this container		
EXPOSE 4000		

# Run		
CMD bundle exec jekyll serve