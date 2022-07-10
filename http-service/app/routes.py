from app import app
from flask import request
import re
import subprocess
import json
import logging
import os

@app.route('/helloworld', methods=['GET'])
def helloworld():
#  Name = request.args.get('name')
  if request.args.get('name') is None:
    return 'Hello Stranger'
  else:
    Name = request.args.get('name')
    Name = re.sub("([a-z])([A-Z])","\g<1> \g<2>", Name)
    return 'Hello '+Name

@app.route('/versionz')
def versionz():
  #getting the latest git hash from ENV
  git_hash = os.getenv('GITHASH')
  #getting project repo name from ENV
  project_name = os.getenv('GITREPO')
  #create a list from data
#  dict_versionz = {'LatestGitHash': git_hash, 'ProjectName': project_name}

#  return {'message': json.dumps(dict_versionz)}
  return git_hash + project_name

logging.basicConfig(
    format="%(asctime)s %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S%z"
)
