FROM jenkins:latest

COPY ["entrypoint.sh", "/"]

USER root

RUN apt-get update && \
    apt-get install --yes --force-yes sudo vim libltdl7 && \
    chmod 755 /entrypoint.sh
    
ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]
