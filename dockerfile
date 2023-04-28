FROM python:3.10.6-slim

WORKDIR /app

COPY TP1.py .

RUN pip install requests

CMD ["python","TP1.py"]