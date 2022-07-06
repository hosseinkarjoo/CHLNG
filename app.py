from flask import Flask, request
import re
app = Flask(__name__)

@app.route('/helloworld', methods=['GET'])
def helloworld():
  Name = request.args.get('name')
  Name = re.sub("([a-z])([A-Z])","\g<1> \g<2>", Name)
  if Name is None:
    return 'Hello Stranger'
  else:
    return 'Hello '+Name
