from flask import Flask
import boto3
import os

app = Flask(__name__)

def get_secret():
    secret_name = os.getenv('API_KEY_SECRET_NAME')
    region_name = "us-east-1"
    client = boto3.client('secretsmanager', region_name=region_name)
    get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    return get_secret_value_response['SecretString']

@app.route('/')
def index():
    api_key = get_secret()
    return f"API Key Retrieved: {api_key}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)