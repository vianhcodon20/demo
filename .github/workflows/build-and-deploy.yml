# File: .github/workflows/build-and-deploy.yml

name: Build and Deploy to Server

on:
  push:
# Kích hoạt (Trigger):
#Quy trình sẽ chạy khi:
# Có một commit được push lên nhánh main.
# Một pull request nhắm đến nhánh main.
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-deploy:
    name: Build and Deploy to Server
    runs-on: self-hosted

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
# Bước 1: Lấy mã nguồn từ repository
# Dùng: actions/checkout@v4.
# Mục đích: Tải toàn bộ mã nguồn từ repository GitHub về để chuẩn bị cho các bước tiếp theo.


      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3
# Bước 2: Thiết lập QEMU
# Dùng: docker/setup-qemu-action@v3.
# Mục đích: Hỗ trợ build Docker image trên nhiều kiến trúc CPU (nếu cần, ví dụ ARM hoặc x86).

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
# Bước 3: Đăng nhập Docker Hub
# Dùng: docker/login-action@v2.
# Mục đích: Đăng nhập vào Docker Hub để có thể đẩy (push) hoặc tải về (pull) Docker image.
# Thông tin đăng nhập: Lấy từ GitHub Secrets (DOCKER_USERNAME và DOCKER_PASSWORD).

      - name: Tags Docker image
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: toandnseta/demo-cicd
# Bước 4: Gắn thẻ (Tag) Docker Image
# Dùng: docker/metadata-action@v5.
# Mục đích: Tự động gắn tag cho Docker image dựa trên thông tin từ repository (ví dụ: commit hash, branch, hoặc tag cụ thể).

      - name: Build and push to Docker Hub
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
# Bước 5: Build và Push Docker Image
# Dùng: docker/build-push-action@v6.
# Mục đích:
# Build Docker image từ mã nguồn hiện tại.
# Push image lên Docker Hub với tên toandnseta/demo-cicd và tag được tự động gắn ở bước trước.

      - name: Deploy to Ubuntu Server
        run: |
          docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
          docker pull toandnseta/demo-cicd:main
          docker ps -q | xargs -r docker stop || true
          docker ps -aq | xargs -r docker rm || true
          docker run -d --name demo-cicd -p 192.168.81.156:8080:80 toandnseta/demo-cicd:main
# Bước 6: Triển khai trên server Ubuntu
# docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
# docker pull toandnseta/demo-cicd:main
# docker stop html-container || true
# docker rm html-container || true
# docker run -d --name html-container -p 192.168.81.156:8080:80 toandnseta/demo-cicd:main
