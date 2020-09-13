FROM elixir:1.10.4-alpine AS builder

ENV MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mkdir /app
WORKDIR /app

COPY . .

RUN mix do deps.get, deps.compile, compile, escript.build

FROM erlang:22-alpine AS app

COPY --from=builder /app/notoriety /usr/local/bin

VOLUME ["/pwd"]
WORKDIR /pwd

ENTRYPOINT ["notoriety"]
