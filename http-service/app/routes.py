from app import app
from flask import request
import re
import subprocess
import json
import logging


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
  #getting the latest git hash
  git_hash = subprocess.run(['git', 'rev-parse', 'HEAD'], stdout=subprocess.PIPE)
  githash = git_hash.stdout.decode('utf-8').strip()
  #get repo name
  project_name = subprocess.run(['git', 'config', '--get', 'remote.origin.url'], stdout=subprocess.PIPE)
  #create a list from data
  cur_dir = project_name.stdout.decode('utf-8').strip()
  dict_versionz = {'LatestGitHash': githash, 'ProjectName': cur_dir}

  return {'message': json.dumps(dict_versionz)}


logging.basicConfig(
    format="%(asctime)s %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S%z"
)
