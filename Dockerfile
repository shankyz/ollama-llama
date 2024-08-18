FROM nvidia/cuda:12.0.1-runtime-ubuntu20.04

# Set environment variables
ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive

# Install tzdata and other necessary packages without recommending additional packages
RUN apt-get update && \
    apt-get install -yq --no-install-recommends tzdata

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    vim \
    wget \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    git \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN python3 -m pip install --upgrade pip

# Install Ollama and grant execution permissions to the Ollama CLI
RUN curl -fsSL https://ollama.com/install.sh | sh

RUN chmod +x /usr/local/bin/ollama

# Start Ollama in the background, wait for it to initialize, then pull the model
RUN (ollama serve &) && \
    sleep 15 && \
    PID=$! && \
    ollama pull llama3.1 && \
    wait $PID

# Set up the working directory
WORKDIR /workspace

# Copy all files from the current directory on your host to /workspace in the container
COPY . /workspace

# Install Python packages from requirements.txt
RUN pip3 install --use-deprecated=legacy-resolver --no-cache-dir -r requirements.txt

# Grant execution permissions to the startup script
RUN chmod +x /workspace/llama_start_up.sh

# Set an environment variable for Ollama host
ENV OLLAMA_HOST=0.0.0.0:11434

# Expose port 11434 for external access
EXPOSE 11434

# Set the entrypoint to run the startup script
ENTRYPOINT ["/bin/bash", "/workspace/llama_start_up.sh"]
