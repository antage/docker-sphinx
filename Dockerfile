FROM debian:stable

RUN \
    apt-get -y -q update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y -q --no-install-recommends install \
        curl \
        ca-certificates \
        gosu \
        sphinxsearch \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /var/log/dpkg.log \
    && curl -#L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o /usr/local/bin/confd \
    && chmod 755 /usr/local/bin/confd \
    && mkdir -p /etc/confd/conf.d \
    && mkdir -p /etc/confd/templates \
    && touch /etc/confd/confd.toml

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
