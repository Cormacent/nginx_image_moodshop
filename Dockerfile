FROM nginx:stable-alpine
COPY --from=zakimaulana/nginxmoodshop:master /app/dist /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf