Install & RUN
--------------------------------------------
- Clone the repository
- cd CHLNG
- git checkout http-service
- pip3.6 install -r requirements.txt
- flask run

Variables
--------------------------------------------
- You can see and change the default vars from .flaskenv file
- to Override set this environment variables:
  FLASK_RUN_PORT, FLASK_RUN_HOST

Running Tests
--------------------------------------------
- to run Unit test for all routes:
  pytest
