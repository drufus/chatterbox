{\rtf1\ansi\ansicpg1252\cocoartf2867
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw18720\paperh27360\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 FROM python:3.11-slim\
\
# Audio + build deps\
RUN apt-get update && apt-get install -y --no-install-recommends \\\
    git \\\
    ffmpeg \\\
    libsndfile1 \\\
    build-essential \\\
 && rm -rf /var/lib/apt/lists/*\
\
WORKDIR /app\
COPY . /app\
\
# Install the package + Gradio UI deps\
RUN pip install --no-cache-dir -U pip \\\
 && pip install --no-cache-dir -e . \\\
 && pip install --no-cache-dir gradio\
\
# Persist caches if you mount /data\
ENV HF_HOME=/data/hf \\\
    TRANSFORMERS_CACHE=/data/hf/transformers \\\
    TORCH_HOME=/data/torch \\\
    XDG_CACHE_HOME=/data/cache\
\
# Gradio bind to container network\
ENV GRADIO_SERVER_NAME=0.0.0.0 \\\
    GRADIO_SERVER_PORT=7860\
\
EXPOSE 7860\
\
# Choose ONE UI to run\
CMD ["python", "gradio_tts_turbo_app.py"]\
}