## Practically this should be done by compose but this will do for
## testing.
docker volume create montagu_shiny_volume
docker network create testing
docker run -d --rm \
       --name montagu-shiny \
       -p 3838:3838 \
       -v montagu_shiny_volume:/srv/shiny-server/apps \
       --network=testing \
       docker.montagu.dide.ic.ac.uk:5000/montagu-shiny:master

docker run --rm --name montagu-shiny-proxy \
       -p 1080:80 \
       -v ${PWD}/Caddyfile:/etc/Caddyfile \
       --network=testing \
       montagu-shiny-proxy
