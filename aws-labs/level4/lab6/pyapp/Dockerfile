FROM python:3.8-slim
WORKDIR /app
COPY app.py /app
RUN pip install flask boto3
CMD ["python", "app.py"]