FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
RUN apt-get update && apt-get install curl -y
RUN useradd -m appuser
USER appuser
ENTRYPOINT ["python3", "app.py"] 
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -f http://localhost:5000/health || exit 1