FROM python:3.8 
# creating a working directory  
WORKDIR /app
# adding source code into the image
COPY . .
#COPY requirements.txt .
RUN pip install -r requirements.txt

EXPOSE 8501

COPY . /app

ENTRYPOINT ["streamlit", "run"]
# telling Docker what command we want to run when our image is executed inside a container
CMD [ "app.py" ]

