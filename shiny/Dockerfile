FROM rocker/shiny

# Add new packages here (in alphabetical order)
RUN install2.r --error \
  dplyr \
  drat

RUN rm -rf /srv/shiny-server/index.hml /srv/shiny-server/[01]*

COPY index.html /srv/shiny-server/index.html
