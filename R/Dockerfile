FROM rocker/tidyverse

VOLUME /docker_output

## Install extra R packages using requirements.R
## Specify requirements as R install commands e.g.
## 
## install.packages("<myfavouritepacakge>") or
## devtools::install("SymbolixAU/googleway")
#RUN R -e 'install.packages(c("dplyr", "tidyr", "lubridate", "gtools", "stringr", "data.table", "viridis", "ggplot2", "ggsci", "RColorBrewer", "ggalt"))'


RUN mkdir /R
COPY . /R
RUN Rscript /R/requirements.R

CMD ["R", "-e", "rmarkdown::render('/R/test.Rmd', output_file='/docker_output/test.docx')"]
