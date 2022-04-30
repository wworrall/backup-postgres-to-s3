FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
  wget \
  curl \
  unzip \
  cron \
  gnupg2 \
  lsb-release

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y postgresql-client-14

# create the log file to be able to run tail
RUN touch /var/log/cron.log

WORKDIR /app

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -r ./awscliv2.zip ./aws

COPY ./run-backup.sh ./start.sh ./

CMD ["./start.sh"]
