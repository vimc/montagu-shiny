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
docker pull docker.montagu.dide.ic.ac.uk:5000/montagu-shiny:i1135_proxy
docker pull docker.montagu.dide.ic.ac.uk:5000/montagu-shiny-proxy:i1135_proxy
docker-compose up --force-recreate
```

Open http://localhost:80/shiny and you should see the shiny page.

Then try http://localhost:80/shiny/sample-apps/ and you should get a `401 Unauthorized` error - the page is protected by caddy's jwt validation.

Then press F12 (Chrome) to open developer console and run in the console:

```
document.cookie="jwt_token=eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ0ZXN0LnVzZXIiLCJwZXJtaXNzaW9ucyI6IipcL2Nhbi1sb2dpbiwqXC9jb3VudHJpZXMucmVhZCwqXC9kZW1vZ3JhcGhpY3MucmVhZCwqXC9lc3RpbWF0ZXMucmVhZCwqXC9tb2RlbGxpbmctZ3JvdXBzLnJlYWQsKlwvbW9kZWxzLnJlYWQsKlwvcmVzcG9uc2liaWxpdGllcy5yZWFkLCpcL3NjZW5hcmlvcy5yZWFkLCpcL3RvdWNoc3RvbmVzLnJlYWQsKlwvdXNlcnMucmVhZCwqXC9yZXBvcnRzLnJlYWQsKlwvcmVwb3J0cy5yZXZpZXcsKlwvcmVwb3J0cy5ydW4iLCJyb2xlcyI6IipcL3VzZXIsKlwvcmVwb3J0cy1yZXZpZXdlciIsImlzcyI6InZhY2NpbmVpbXBhY3Qub3JnIiwiZXhwIjoxNTE1MDg2MjY3fQ.UtkrLZ2ME0-ux2FhAgQxiQGeadWJDhZjMgOn5yiw0tVk-DLwgRR0tssadUgesBJPc3SaS0Y11k7pCChZ70QtbTnSca5YW-sBivJc1cBtc5doB6PPkRTVk3QjJN8Rpsogp5YdRmoF-UEPfAPn9ozZfYHv-ujUr1CHoXkOTefo9glIOUvQA382q_84rt2SuUNWgQuIWd4B2DE_xftgLnJ7HwCdZtB7YXNoche2biTuWWymHhIk6mC-9QsKw3z8zYlhDNIezEhUz-NKaV6bJIXbgG6uvCYibNVQz0gTVZiUHQq-fukvXL9nbZaUlWsAAJdtoQvntiHuELqXuYX86yIF3Q"
```

This sets a cookie that caddy can validate with the public key that is mounted into the container.  Now going to http://localhost:80/shiny/sample-apps/ should work fine.

At this point nginx is passing the request to caddy, who is validating the jwt, and onto shiny!
