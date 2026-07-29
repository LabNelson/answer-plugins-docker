FROM apache/answer:2.0.2

RUN answer build \
    --with github.com/apache/answer-plugins/captcha-google-v2@v1.0.6 \
    --with github.com/apache/answer-plugins/connector-github@v1.2.9 \
	--with github.com/apache/answer-plugins/cache-redis@1.3.1 \
	--with github.com/apache/answer-plugins/search-elasticsearch@v1.2.9 \
	--with github.com/apache/answer-plugins/reviewer-akismet@v1.0.6