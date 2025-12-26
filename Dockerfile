FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    libsndfile1 \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# IMPORTANT: src-layout fix
ENV PYTHONPATH=/app/src

RUN pip install --no-cache-dir -U pip \
 && pip install --no-cache-dir torch torchaudio \
 && pip install --no-cache-dir gradio numpy scipy soundfile \
 && (pip install --no-cache-dir -r requirements.txt || true)

ENV HF_HOME=/data/hf \
    TRANSFORMERS_CACHE=/data/hf/transformers \
    TORCH_HOME=/data/torch \
    XDG_CACHE_HOME=/data/cache \
    GRADIO_SERVER_NAME=0.0.0.0 \
    GRADIO_SERVER_PORT=7860

EXPOSE 7860

CMD ["python", "gradio_tts_turbo_app.py"]
