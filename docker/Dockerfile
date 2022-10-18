FROM elixir:1.14-alpine

ENV PHOENIX_VERSION 1.6.13

# Add inotify-tools
RUN apk add --no-cache bash inotify-tools

# Create required dirs
RUN mkdir /app

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# Install phoenix
RUN mix archive.install hex phx_new $PHOENIX_VERSION

# Set /app as workdir
WORKDIR /app