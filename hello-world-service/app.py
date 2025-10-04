from flask import Flask
import boto3
import os
import json
import logging
from datetime import datetime

# Configure JSON logging
class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_entry = {
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno
        }
        return json.dumps(log_entry)

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Remove existing handlers
for handler in logger.handlers[:]:
    logger.removeHandler(handler)

# Add stream handler with JSON formatter
handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logger.addHandler(handler)

app = Flask(__name__)

@app.route('/')
def hello():
    # Log the request
    logger.info("Hello endpoint accessed", extra={
        "route": "/",
        "method": "GET",
        "service": "hello-world"
    })
    
    # Read from SSM Parameter Store
    ssm = boto3.client('ssm', region_name='ap-south-1')
    try:
        parameter = ssm.get_parameter(Name='/hello-world/message', WithDecryption=True)
        message = parameter['Parameter']['Value']
        logger.info("Successfully retrieved SSM parameter", extra={
            "parameter_name": "/hello-world/message",
            "service": "hello-world"
        })
    except Exception as e:
        message = "Hello from AWS EKS!"
        logger.error("Failed to retrieve SSM parameter", extra={
            "parameter_name": "/hello-world/message",
            "error": str(e),
            "service": "hello-world"
        })
    
    return f"<h1>{message}</h1><p>Running on EKS</p>"

@app.route('/health')
def health():
    logger.info("Health check endpoint accessed", extra={
        "route": "/health", 
        "method": "GET",
        "service": "hello-world"
    })
    return {"status": "healthy", "timestamp": datetime.utcnow().isoformat()}

if __name__ == '__main__':
    logger.info("Starting hello-world application", extra={
        "port": 8080,
        "environment": "production",
        "service": "hello-world"
    })
    app.run(host='0.0.0.0', port=8080)
