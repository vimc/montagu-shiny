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
