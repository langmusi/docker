Running R in Docker - Part 1,2,3 - Knitting RMarkdown
https://www.cascadia-analytics.com/2018/07/23/docker-r-p3.html  --> useful


YOUTUBE:
Docker and R by Thomas Rehman (8/30/2017)  --> check at 19:28min


docker run --rm -p 8787:8787 -e USER=guest -e PASSWORD=guest -v /Users/vladdsm/Shared:/home/guest/r-docker tmlts/r-tidyverse-h2o
docker run --rm -p 8787:8787 -e USER=guest -e PASSWORD=gues - v /Users/LIUM3478/OneDrive Corp/OneDrive - Atkins Ltd/Work_Atkins/Docker/R/output rstudio

"C:\Users\LIUM3478\OneDrive Corp\OneDrive - Atkins Ltd\Documents\docker_output"

docker build -t rmarkdown .
docker run -it --rm --mount "type=bind,source=C:/Users/LIUM3478/OneDrive Corp/OneDrive - Atkins Ltd/Documents/docker_output,target=/docker_output" rmarkdown