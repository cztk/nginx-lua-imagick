
FROM debian:bookworm

RUN apt-get update
RUN apt-get install -y luajit2 luarocks libmagickwand-dev imagemagick libnginx-mod-http-lua
RUN luarocks install magick

# mounted files could be messed up too easily
# just start a new generation / version
COPY nginx.conf /etc/nginx/nginx.conf
COPY lua/ /etc/nginx/lua/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
