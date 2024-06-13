FROM chainsafe/lodestar:${LODESTAR_VERSION:-v1.18.1}

COPY ./run.sh /opt/lodestar/run.sh

RUN chmod +x /opt/lodestar/run.sh

ENTRYPOINT /opt/lodestar/run.sh
