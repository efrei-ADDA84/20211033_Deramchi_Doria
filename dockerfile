FROM python:3.10.6-slim

WORKDIR /app

COPY TP1.py .

RUN pip install fastapi
RUN pip install requests
RUN pip install uvicorn[standard]

CMD ["uvicorn","TP1:app","--host", "0.0.0.0","--port","8081"]