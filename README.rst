Build & RUN
--------------------------------------------
- docker build -t flask:latest .
- docker container run -d --name flask-app -p 8080:8080 flask 

Variables
--------------------------------------------
- Default variables are in .flaskenv
- to Override do: docker container run -d --name flask-app -p 8080:8090 -e FLASK_RUN_PORT=8090 flask

Running Tests
--------------------------------------------
- docker container exec flask-app pytest
