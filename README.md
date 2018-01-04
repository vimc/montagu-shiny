# Shiny server for montagu

## Workflow & design

* the container here is built on teamcity
* this container is then run as part of the montagu constellation, exposing the port 3838 for now (eventually hide this and run via the proxy or the reporting api because this is not authenticated and anyone on the network could just access it)
* orderly builds shiny apps; these will be self contained directories (e.g., `shiny/`) within a report.  Mostly this will be concerned with saving out data via `save` to be loaded within the app with `load`.
* orderly copies the generated reports over into the shiny volume (which is also mounted into the orderly container) based on a bit of metadata `shiny.yml` in the orderly root.

## Deploy the standalone container for testing

```
docker volume create montagu_shiny_volume
docker run -d --rm --name montagu-shiny \
  -p 3838:3838 \
  -v montagu_shiny_volume:/srv/shiny-server/apps \
  docker.montagu.dide.ic.ac.uk:5000/montagu-shiny:i1135
```

## Proxy hell

This repo mimics most of the setup in montagu where we have:

* shiny server running as `shiny` on `3838`
* caddy proxying and doing jwt validation as `shiny_proxy` on `80`
* nginx doing the world-facing proxying as `proxy` on `80`

Caddy is only required because of the jwt validation, which nginx does not support in the free version.

Within `nginx/` run

```
./build.sh
docker-compose up
```

If the jwt validation bits are not commented out there's more work to do.
