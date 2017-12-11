FROM rocker/shiny

# Add new packages here (in alphabetical order)
RUN install2.r --error \
  drat

RUN rm -rf /srv/shiny-server/index.hml /src/shiny-server/[0-9]+_*

COPY index.html /srv/shiny-server
