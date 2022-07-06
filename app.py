from flask import Flask, request
import re
import subprocess

app = Flask(__name__)

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
  git_hash = subprocess.run(['git', 'rev-parse', 'HEAD'], stdout=subprocess.PIPE)
  return git_hash.stdout.decode('utf-8')
