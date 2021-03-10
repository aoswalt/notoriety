ARG ELIXIR_VER=1.11.3
ARG OTP_VER=23.2.7
ARG OS=alpine-3.13.2
# ARG OS=focal-20210119

FROM hexpm/elixir:${ELIXIR_VER}-erlang-${OTP_VER}-${OS} AS builder

ENV MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mkdir /app
WORKDIR /app

COPY . .

RUN mix do deps.get, deps.compile, compile, escript.build

FROM hexpm/erlang:${OTP_VER}-${OS} AS app

COPY --from=builder /app/notoriety /usr/local/bin

VOLUME ["/pwd"]
WORKDIR /pwd

ENTRYPOINT ["notoriety"]
