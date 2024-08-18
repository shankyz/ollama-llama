#!/bin/bash

# Start Ollama service in the background
echo "Starting ollama"
/usr/local/bin/ollama serve &

# Capture the process ID of the Ollama service
serve_pid=$!

# Wait for 10 seconds to allow the service to initialize
sleep 10

# Run the llama3.1 model
echo "Running llama 3.1"
/usr/local/bin/ollama run llama3.1

# Wait for the Ollama service to complete
wait $serve_pid
