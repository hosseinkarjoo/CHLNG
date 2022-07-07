from flask import Flask, request
import re
import subprocess

app = Flask(__name__)

@app.route('/helloworld', methods=['GET'])
def helloworld():
  #checking if there is any url parameters
  if request.args.get('name') is None:
    return 'Hello Stranger'
  else:
    #get the parameter
    Name = request.args.get('name')
    #Camel-Case get by space with regex
    Name = re.sub("([a-z])([A-Z])","\g<1> \g<2>", Name)
    return 'Hello '+Name

@app.route('/versionz')
def versionz():
  #getting the latest git hash
  git_hash = subprocess.run(['git', 'rev-parse', 'HEAD'], stdout=subprocess.PIPE)
  githash = git_hash.stdout.decode('utf-8').strip()
  #current directory for repo name
  pwd_cm = subprocess.run(['pwd'], stdout=subprocess.PIPE)
  pwd = pwd_cm.stdout.decode('utf-8')
  project_name = pwd.split("/")
  #create a list from data
  cur_dir = project_name[-1].strip()
  dict_versionz = {'LatestGitHash': githash, 'ProjectName': cur_dir}

  return json.dumps(dict_versionz)

logging.basicConfig(
    format="%(asctime)s %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S%z"
)
