Dockerfile -to create a custom image which makes use of llama3.1
requiremnets.txt - file which has all the dependencies
llama_start_up.sh - shell script which runs on the entrypoint of the image

Here’s a step-by-step guide to building, optionally pushing, and running the Docker image for LLaMA 3.1, followed by a cURL command to interact with the model:
1. Build the Docker Image:
docker build . -t <reponame>/Ollama:llama3_1
	Replace <reponame> with your Docker repository name.
	This command builds the Docker image using the Dockerfile in the current directory (.) and tags it as Ollama:llama3_1.
2. (Optional) Push the Image to a Docker Repository:
If you want to push the built image to a Docker repository or any other container registry, use the following command:
docker push <reponame>/Ollama:llama3_1
•	Again, replace <reponame> with your actual Docker repository name.
•	Ensure you are logged into your Docker account (docker login) before pushing.

3. Run the Docker Container:
docker run -d --gpus all -p 8009:11434 <reponame>/Ollama:llama3_1
•	--gpus all: This flag tells Docker to use all available GPUs. You can specify a particular GPU by    using --gpus '"device=0"' to use only the first GPU, for example.
•	-d: Runs the container in detached mode.
•	-p 8009:11434: Maps port 8009 on the host to port 11434 on the container.
•	<reponame>/Ollama:llama3_1: Replace this with your Docker image name

4. Interact with the Running Model using curl:

curl http://127.0.0.1:8009/api/chat -d '{ "model": "llama3", "messages": [ { "role": "user", "content": "List the Continents" } ], "stream": false }'

•	This curl command sends a POST request to the running model, asking the question, "List the continents".
•	The response will be returned from the LLaMA 3.1 model.

This command will run your container using the GPU(s) available on your system, allowing LLaMA 3.1 to leverage the GPU for processing.
