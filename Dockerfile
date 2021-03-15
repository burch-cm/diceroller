FROM openanalytics/r-base

MAINTAINER Kitt Burch "cmburch@cmburch.me"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*


# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'shinydashboard', 'ggplot2'), repos='https://cloud.r-project.org/')"

# install dependencies of the diceroller app
RUN R -e "install.packages(c('scales', 'magrittr', 'dplyr'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /root/diceroller
COPY diceroller /root/diceroller

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/diceRoller')"]
