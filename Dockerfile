# PostgreSQL

FROM cashpad/base
MAINTAINER Yann Berthou

ENV DEBIAN_FRONTEND noninteractive






RUN apt-get -qq update
RUN apt-get -yqq upgrade
RUN apt-get -yqq install wget ca-certificates

# Install PosgresSQL 9.3
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
#RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get -qq update

# Allows launch services
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN apt-get -yqq install postgresql-9.3 \
    && echo "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" | su postgres -c psql \
    && su postgres -c "createdb -O docker docker"

ADD supervisor.conf /etc/supervisor/conf.d/postgresql.conf
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf


VOLUME ["/var/lib/postgresql"]
EXPOSE 5432

#CMD ["/usr/bin/supervisord"]
ENTRYPOINT ["/usr/bin/supervisord"]
