# sphinx

Sphinx 2.2.x

Based on debian:stable.

## Building

Just run `make`.

## Volumes

* `/etc/confd/templates/sphinx.conf.tmpl` - confd template without `searchd` section,
  available keys: "/mysql/host", "/mysql/db", "/mysql/user", "/mysql/password".
* `/var/lib/sphinxsearch/data`

## Exposed ports

* 9312
* 9306

## Environment variables

* `MYSQL_HOST`
* `MYSQL_DB`
* `MYSQL_USER`
* `MYSQL_PASSWORD`
