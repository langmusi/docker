FROM python:3.8 
# creating a working directory  
WORKDIR /hjulanalys
# adding source code into the image
COPY . .
#COPY requirements.txt .
RUN pip install -r requirements.txt
# # adding source code into the image
# COPY . . 
# telling Docker what command we want to run when our image is executed inside a container
CMD [ "python", "predict.py" ]


