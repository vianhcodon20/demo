name: "Build and deploy to server"

on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

jobs:
  deploy:
    name: Deploy to server
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Login to docker hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Tags docker image
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ secrets.DOCKER_USERNAME }}/demo-cicd # Change this to your docker image name

      - name: Build and push to docker hub
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          script: |
            echo "Starting deployment to the server..."
            
            # Check if SSH connection works
            ssh -o StrictHostKeyChecking=no -i ${{ secrets.SSH_KEY }} ${{ secrets.USERNAME }}@${{ secrets.HOST }} 'echo "SSH connection established!"'
            
            # Pull image from Docker Hub
            docker pull ${{ steps.meta.outputs.tags }}
            
            # Remove old container if it exists
            docker rm -f demo-cicd &>/dev/null || true  # Ensure no error if the container doesn't exist
            
            # Run the new container
            docker run -it -d --name demo-cicd -p 8080:80 ${{ steps.meta.outputs.tags }}
          