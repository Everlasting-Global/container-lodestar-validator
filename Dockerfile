FROM chainsafe/lodestar:${LODESTAR_VERSION:-v1.18.1}

COPY ./run-many.sh /opt/lodestar/run.sh

ENTRYPOINT /opt/lodestar/run.sh
