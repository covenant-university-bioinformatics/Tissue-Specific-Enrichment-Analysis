FROM ubuntu:18.04 
ENV CI=true
ENV PIP_IGNORE_INSTALLED=0

WORKDIR /app

## install R 
## to stop interactve  input tzdata (timezone)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos
RUN  apt-get update && apt-get -y install r-base r-base-dev
RUN apt-get -y install libcurl4-openssl-dev ## to resolve the issue this issue ---> installation of package 'RCurl' had non-zero exit status

RUN  R -e "install.packages(c('deTS', 'pheatmap'),dependencies=TRUE, repos='http://cran.rstudio.com/')"

COPY scripts/ ./scripts/

RUN apt-get install -y dos2unix
RUN dos2unix /app/scripts/script.sh
RUN chmod 775 /app/scripts/script.sh
RUN chmod 775 /app/scripts/deTS.R

#ENTRYPOINT ["bash", "/app/scripts.sh"]
CMD ["bash", "/app/scripts/script.sh"]


