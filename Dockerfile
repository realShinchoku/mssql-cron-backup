FROM mcr.microsoft.com/mssql/server:2022-latest
ENV ACCEPT_EULA=Y
ENV MSSQL_TCP_PORT=1433
ENV CRON_SCHEDULE_TIME="0 0 * * *"
EXPOSE 1433

USER root

RUN apt-get update && apt-get -y install cron vim

COPY backup.sql /var/opt/mssql/cron/backup.sql

CMD cron \
    && echo "$CRON_SCHEDULE_TIME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -i /var/opt/mssql/cron/backup.sql >> /var/opt/mssql/backup.log" > /var/opt/mssql/cron/backup-crontab \
    && crontab /var/opt/mssql/cron/backup-crontab \
    && /opt/mssql/bin/sqlservr
