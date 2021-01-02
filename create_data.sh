#!/bin/bash

apt-get -qq update
apt-get -qq install -y lsb-release software-properties-common wget curl vim htop git byobu libcurl4-openssl-dev libssl-dev
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
add-apt-repository "deb [arch=amd64,i386] https://cloud.r-project.org/bin/linux/ubuntu `lsb_release -sc`-cran35/"
apt-get -qq update
apt-get -qq install -y r-base-dev virtualenv

cd /usr/local/lib/R
chmod o+w site-library

cd ~
mkdir -p .R
echo 'CFLAGS=-O3 -mtune=native' >> ~/.R/Makevars
echo 'CXXFLAGS=-O3 -mtune=native' >> ~/.R/Makevars

Rscript -e 'install.packages(c("jsonlite","bit64","devtools","rmarkdown"), repos="https://cloud.r-project.org")'
Rscript -e 'install.packages("data.table",repos = "http://cran.us.r-project.org")'

cd /benchmark

# generate data for groupby
Rscript _data/groupby-datagen.R 1e7 1e2 0 0
Rscript _data/groupby-datagen.R 1e8 1e2 0 0

Rscript _data/join-datagen.R 1e7 0 0 0 ## 1e7 rows, 0 ignored, 0% NAs, random order
Rscript _data/join-datagen.R 1e8 0 5 1 ## 1e8 rows, 0 ignored, 5% NAs, sorted order
