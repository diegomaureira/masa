# Use the official PyTorch image as base
FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        git \
        curl \
        ca-certificates \
        build-essential \
        vim \
        unzip \
        sudo \
        python3-distutils \
        libgl1-mesa-glx \
        libglib2.0-0 \
        libsm6 \
        libxrender1 \
        libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN python -m pip install --upgrade pip setuptools wheel

RUN pip install -U openmim && \
    mim install mmengine && \
    pip install mmcv==2.1.0 -f https://download.openmmlab.com/mmcv/dist/cu118/torch2.1/index.html && \
    mim install mmdet && \
    pip install supervision && \
    pip install transformers==4.38.2 && \
    pip install nltk && \
    pip install h5py && \
    pip install einops && \
    pip install seaborn && \
    pip install fairscale && \
    pip install nltk && \
    pip install git+https://github.com/openai/CLIP.git --no-deps && \
    pip install git+https://github.com/siyuanliii/TrackEval.git && \
    pip install git+https://github.com/SysCV/tet.git#subdirectory=teta && \
    pip install git+https://github.com/scalabel/scalabel.git@scalabel-evalAPI && \
    pip install git+https://github.com/TAO-Dataset/tao && \
    pip install numpy==1.26.4

# Set NLTK data directory
ENV NLTK_DATA=/opt/conda/nltk_data

# Download necessary NLTK resources
RUN python -m nltk.downloader \
    punkt \
    punkt_tab \
    wordnet \
    stopwords \
    averaged_perceptron_tagger \
    averaged_perceptron_tagger_eng \
    -d /opt/conda/nltk_data

# MASA working directory
WORKDIR /workspace/masa
