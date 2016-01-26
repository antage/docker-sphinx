FROM debian:stable

RUN \
    echo "deb http://httpredir.debian.org/debian/ jessie-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get -y -q update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y -q --no-install-recommends install \
        curl \
        ca-certificates \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y -q --no-install-recommends -t jessie-backports install \
        sphinxsearch \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /var/log/dpkg.log \
    && curl -#L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o /usr/local/bin/confd \
    && chmod 755 /usr/local/bin/confd \
    && mkdir -p /etc/confd/conf.d \
    && mkdir -p /etc/confd/templates \
    && touch /etc/confd/confd.toml \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

EXPOSE 9312
EXPOSE 9306

ENV LANG=C

RUN chown nobody:nogroup /var/lib/sphinxsearch/data
RUN chown nobody:root /var/run/sphinxsearch && chmod 700 /var/run/sphinxsearch
COPY confd/sphinx.toml /etc/confd/conf.d/
COPY conf/_sphinx_searchd.conf /etc/sphinxsearch/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sphinx"]
