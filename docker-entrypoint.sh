#!/bin/bash
set -e

echo "Updating sphinx configuration files."
/usr/local/bin/confd -onetime -backend env
cat /etc/sphinxsearch/_sphinx.conf /etc/sphinxsearch/_sphinx_searchd.conf > /etc/sphinxsearch/sphinx.conf

if [ "$1" = 'sphinx' ]; then
    echo "Starting sphinx in foreground."
    exec gosu nobody:nogroup /usr/bin/searchd --console --config /etc/sphinxsearch/sphinx.conf --pidfile /var/run/sphinxsearch/searchd.pid
fi

if [ "$1" = 'index' ]; then
    if [ ${#@} -eq 1 ]; then
        indexes="--all"
    else
        indexes="${@:2}"
    fi
    if [ -f /var/run/sphinxsearch/searchd.pid ]; then
        args="--rotate"
    fi
    echo "Start full indexing."
    exec gosu nobody:nogroup /usr/bin/indexer $args $indexes
fi

exec "$@"
