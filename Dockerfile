FROM jenkins:2.32.1
LABEL Version="0.1"

COPY ["entrypoint.sh", "/"]

USER root

RUN apt-get update && \
    apt-get install sudo && \
    chmod 755 /entrypoint.sh

ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]
