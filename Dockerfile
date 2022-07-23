FROM alpine:latest

LABEL Version="1.0" \
      Autor="J. Andres B. G." \
      Date="Julio 2022"

RUN apk update --no-cache && \
    apk add aws-cli bash postgresql curl && \
    rm -rf /var/cache/apk/*

WORKDIR /backups
COPY backup.sh .
RUN chmod +x backup.sh

CMD /backups/backup.sh