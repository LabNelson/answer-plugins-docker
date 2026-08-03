FROM apache/answer:2.0.2 AS answer-builder

FROM golang:1.25-alpine AS golang-builder

COPY --from=answer-builder /usr/bin/answer /usr/bin/answer

RUN apk --no-cache add \
    build-base git bash nodejs npm && \
    npm install -g pnpm@10.7.0

RUN answer build \
    --with github.com/apache/answer-plugins/connector-github@1.2.11 \
	--with github.com/apache/answer-plugins/cache-redis@v1.3.1 \
	--with github.com/apache/answer-plugins/search-elasticsearch@1.2.11 \
	--with github.com/apache/answer-plugins/reviewer-akismet@v1.0.6 \
    --output /usr/bin/new_answer

FROM alpine
LABEL maintainer="LabNelson"

ARG TIMEZONE
ENV TIMEZONE=${TIMEZONE:-"Europe/Berlin"}

RUN apk --no-cache add \
        bash \
        ca-certificates \
        curl \
        dumb-init \
        gettext \
        openssh \
        sqlite \
        gnupg \
        tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone

COPY --from=golang-builder /usr/bin/new_answer /usr/bin/answer
COPY --from=answer-builder /data /data
COPY --from=answer-builder /entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

VOLUME /data
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]