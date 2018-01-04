FROM rocker/shiny

# Add new packages here (in alphabetical order)
RUN install2.r --error \
  dplyr \
  drat

RUN rm -rf /srv/shiny-server/index.hml /srv/shiny-server/[01]* && \
        mkdir -p /srv/shiny-server/shiny && \
        mv /srv/shiny-server/sample-apps /srv/shiny-server/shiny

COPY root.html /srv/shiny-server/index.html
COPY index.html /srv/shiny-server/shiny/index.html
