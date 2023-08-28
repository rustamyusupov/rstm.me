FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY src ./
COPY maintain/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
