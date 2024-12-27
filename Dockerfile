# Sử dụng base image Nginx để phục vụ file tĩnh
FROM nginx:latest

# Copy các file tĩnh của bạn vào thư mục mặc định của Nginx
COPY . /usr/share/nginx/html

# Expose port 80 để phục vụ nội dung
EXPOSE 80

# Chạy Nginx ở foreground
CMD ["nginx", "-g", "daemon off;"]

