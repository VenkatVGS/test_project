from flask import Flask
import boto3
import os

app = Flask(__name__)

@app.route('/')
def hello():
    # Read from SSM Parameter Store
    ssm = boto3.client('ssm', region_name='ap-south-1')
    try:
        parameter = ssm.get_parameter(Name='/hello-world/message', WithDecryption=True)
        message = parameter['Parameter']['Value']
    except:
        message = "Hello from AWS EKS!"
    
    return f"<h1>{message}</h1><p>Running on EKS</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
