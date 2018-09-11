# Container for restoring postgres on GCE

FROM google/cloud-sdk:alpine

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community postgresql-client

# Set default timeout to 5 seconds
ENV PGCONNECT_TIMEOUT=5

# Copy local GCE credentials to contaier
ADD credentials.json ./credentials.json

ADD restore.sh /usr/bin/restore

RUN chmod +x /usr/bin/restore
