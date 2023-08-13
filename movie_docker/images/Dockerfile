FROM UBUNTU:latest
WORKDIR /SPIDER_ONSITE_AUG13/images
COPY ./getmovieData.sh /images
RUN apt-get update && apt-get install -y wget
RUN chmod +x getmovieData.sh
CMD [ "" ]