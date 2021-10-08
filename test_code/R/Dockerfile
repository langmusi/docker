FROM rocker/tidyverse

VOLUME /docker_output

RUN R -e 'install.packages(c("dplyr", "tidyr", "lubridate", "gtools", "stringr", "data.table", "viridis", "ggplot2", "ggsci", "RColorBrewer", "ggalt"))'

RUN mkdir /R
COPY . /R
#COPY Functions_MR.R /R

CMD ["R", "-e", "rmarkdown::render('/R/test.Rmd', output_file='/docker_output/test.docx')"]
