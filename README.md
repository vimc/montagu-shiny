# Shiny server for montagu

## Workflow & design

* container here is built on teamcity
* add this into the montagu constellation, exposing the ports 3838 for now (eventually hide this and run via the proxy)
* orderly builds apps; these will be self contained directories `shiny/` within a report
* _something_ copies these over into the shiny volume as `/src/shiny-server/apps/<report-name>/<id>` and set up a symlink to the latest

## Deploy the standalone container for testing

```
docker volume create montagu_shiny_volume
docker run -d --rm --name montagu-shiny \
  -p 3838:3838 \
  -v montagu_shiny_volume:/srv/shiny-server/apps \
  docker.montagu.dide.ic.ac.uk:5000/montagu-shiny:i1135
```
