# Node.js is taken from a freshly pulled official image so security releases
# do not have to wait for an upstream Lodestar rebuild.
ARG NODE_IMAGE=node:24-slim
FROM ${NODE_IMAGE} AS patched-node

FROM chainsafe/lodestar:v1.50.1

COPY --from=patched-node /usr/local/bin/node /usr/local/bin/node
COPY ./run.sh /opt/lodestar/run.sh

RUN chmod +x /opt/lodestar/run.sh

# Same entrypoint as the upstream image, so the image can run any Lodestar
# command (beacon, validator, ...). The validator startup script is still
# shipped; use `entrypoint: /opt/lodestar/run.sh` to run it.
ENTRYPOINT ["node", "./packages/cli/bin/lodestar"]
