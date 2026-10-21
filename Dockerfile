# Node.js is taken from a freshly pulled official image so security releases
# do not have to wait for an upstream Lodestar rebuild.
ARG NODE_IMAGE=node:24-slim
FROM ${NODE_IMAGE} AS patched-node

FROM chainsafe/lodestar:v1.50.0

COPY --from=patched-node /usr/local/bin/node /usr/local/bin/node
COPY ./run.sh /opt/lodestar/run.sh

RUN chmod +x /opt/lodestar/run.sh

ENTRYPOINT /opt/lodestar/run.sh
