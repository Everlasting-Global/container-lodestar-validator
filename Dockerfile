FROM chainsafe/lodestar:v1.28.1

COPY ./run.sh /opt/lodestar/run.sh

RUN chmod +x /opt/lodestar/run.sh

ENTRYPOINT /opt/lodestar/run.sh
