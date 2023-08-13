FROM mongo:latest
WORKDIR /spider_onsite_aug13/movie_docker
COPY . .
RUN sudo apt-get install -y jq
RUN chmod +x getmovieData.sh
CMD [ "docker exec -i mongo1 use omdb" ]

