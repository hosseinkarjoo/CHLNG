FROM python:latest

RUN mkdir /app     
WORKDIR /app
COPY ./http-service/requirements.txt /app/   
RUN  pip install -r  requirements.txt
COPY ./http-service/ /app/

ARG GITHASH
ARG GITREPO
ENV GITHASH=$GITHASH
ENV GITREPO=$GITREPO

ENTRYPOINT ["flask", "run"]
