## Practically this should be done by compose but this will do for
## testing.
docker volume create montagu_shiny_volume
docker network create testing
docker run -d --rm \
       --name shiny \
       -v montagu_shiny_volume:/srv/shiny-server/apps \
       --network=testing \
       docker.montagu.dide.ic.ac.uk:5000/montagu-shiny:master

# Get onto science, into the montagu_api_1 container and within
# /etc/montagu/api/token_key/ run:
openssl rsa -pubin -in public_key.der -inform DER -outform PEM

# Save the contents of that as public_key.pem

# Set the key this way, or set it with a path in the caddyfile, either work
PUBLIC_KEY=$(cat public_key.pem)
docker run --rm --name montagu-shiny-proxy \
       -p 1080:80 \
       -e "JWT_PUBLIC_KEY=$PUBLIC_KEY" \
       --network=testing \
       docker.montagu.dide.ic.ac.uk:5000/montagu-shiny-proxy:i1135_proxy

# Open https://support.montagu.dide.ic.ac.uk:11443/reports/ and login if needed
#
# Press F12 to open developer tools and F5 to refresh
#
# Select the reports/ item that corresponds to /reports/api/v1
#
# On Request headers select "view source"
#
# Copy the "Authorization" header
#
# Go to http://localahost:1080
#
# Press F12 for developer tools
#
# Add document.cookie="jwt_token=<token>" where "<token>" is the but
# starting with eyJhb...
#
# Or curl with
curl -v http://localhost:1080 -H "Authorization: Bearer eyJhb..."
