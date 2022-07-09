FROM python:latest

RUN mkdir /app     
WORKDIR /app
COPY ./http-service/requirements.txt /app/   
RUN  pip install -r  requirements.txt
COPY ./http-service/ /app/

ENTRYPOINT ["flask", "run"]
