from flask import Flask, request

app = Flask(__name__)

@app.route('/helloworld', methods=['GET'])
def helloworld():
  Name = request.args.get('name')
  if Name is None:
    return 'Hello Stranger'
  else:
    return 'Hello '+Name
