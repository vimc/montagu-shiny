# Shiny server for montagu

```
docker volume create montagu_shiny_volume
docker run -d --rm --name montagu-shiny \
  -p 3838:3838 \
  -v montagu_shiny_volume:/srv/shiny-server/apps \
  docker.montagu.dide.ic.ac.uk:5000/montagu-shiny:i1135
```
