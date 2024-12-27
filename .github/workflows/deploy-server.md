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
      - name: Deploy to server
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.HOST }}  # Server address
          username: ${{ secrets.USERNAME }}  # Username for server login
          key: ${{ secrets.SSH_KEY }}  # Private key for server login
          port: 22  # Ensure the correct port is used
          timeout: 30s
          command_timeout: 10m
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
