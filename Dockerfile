FROM ubuntu:trusty

ENV APP_PATH="/app"

RUN mkdir -p $APP_PATH

COPY . $APP_PATH

EXPOSE 8080

WORKDIR $APP_PATH

CMD ["./gameserver.sh"]
