FROM ubuntu:24.04

ARG IMAGE_NAME=myproject
ENV IMAGE_NAME=$IMAGE_NAME

# Set timezone
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    libvips42 \
    cron \
    vim \
    wget \
    libreadline-dev \
    zlib1g-dev \
    libxml2-dev \
    libssl-dev \
    libyaml-dev \
    tzdata \
    ca-certificates \
    gcc \
    ruby-dev \
    libxslt-dev \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Ruby version
ENV RUBY_VERSION=3.3.4

# Install ruby
RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc &&\
  mkdir /src && cd /src && git clone https://github.com/rbenv/ruby-build.git &&\
  cd /src/ruby-build && ./install.sh &&\
  cd / && rm -rf /src/ruby-build && ruby-build $RUBY_VERSION /usr/local

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle
# Silence Bundler's root warning
ENV BUNDLE_SILENCE_ROOT_WARNING=1

# Configure bundler
ENV BUNDLER_VERSION='2.4.7' \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  MAKE="make --jobs 8"

# Upgrade RubyGems and install specific Bundler version
RUN gem update --system
RUN gem install bundler --no-document -v $BUNDLER_VERSION

# App Development
ENV APP_HOME=/usr/src/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy application code
COPY . $APP_HOME

# Configure bundler
ENV BUNDLER_VERSION='2.4.7' \
  BUNDLE_JOBS=8 \
  BUNDLE_RETRY=3 \
  MAKE="make --jobs 8"

ENV RAILS_ENV=production

RUN bundle config set --local without 'development' && \
    bundle config --local production true
RUN bundle lock --add-platform x86_64-linux

# Upgrade RubyGems and install specific Bundler version
RUN gem update --system
RUN gem install bundler --no-document -v $BUNDLER_VERSION


RUN bundle install
RUN mkdir -p tmp/pids

RUN SECRET_KEY_BASE=1 rails assets:precompile

ENTRYPOINT ["docker/entrypoint.sh"]
