FROM apache/answer:v2.0.2

RUN answer build \
    --with github.com/LabNelson/answer-plugins-docker/connector-github \
	--with github.com/apache/answer-plugins/cache-redis \
	--with github.com/apache/answer-plugins/search-elasticsearch \
	--with github.com/apache/answer-plugins/reviewer-akismet
    # weitere Plugins hier ergänzen