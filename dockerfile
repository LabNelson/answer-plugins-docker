FROM apache/answer:2.0.2 AS builder

USER root

RUN apk add --no-cache go git nodejs npm

RUN npm install -g pnpm@9

RUN answer build \
    --with github.com/apache/answer-plugins/captcha-google-v2@v1.0.6 \
    --with github.com/apache/incubator-answer-plugins/connector-github@v1.2.9 \
	--with github.com/apache/answer-plugins/cache-redis@v1.3.1 \
	--with github.com/apache/incubator-answer-plugins/search-elasticsearch@v1.2.9 \
	--with github.com/apache/answer-plugins/reviewer-akismet@v1.0.6
	
FROM apache/answer:2.0.2

COPY --from=builder /usr/bin/answer /usr/bin/answer