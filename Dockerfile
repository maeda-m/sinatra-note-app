ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-bullseye

RUN set -eux; \
  apt update; \
  apt install -y --no-install-recommends \
    \
    libpq-dev \
  ; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sinatra-note-app

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "bash" ]
