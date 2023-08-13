#! /usr/bin/bash

MONGO_HOST="mongodb://mongo:27017"
DATABASE="omdb"
COLLECTIONS=("movies" "actors" "Directors" "genres")
movie_name=$1
#omdb_url=http://www.omdbapi.com/?t=$movie_name&apikey=6209fe8e
curl -s "http://www.omdbapi.com/?t=$movie_name&apikey=6209fe8e" > moviedetails.txt
response=$(cat moviedetails.txt)
#det= cat moviedetails.txt | awk "/Title/{print}" 
#echo $det
Title=$(echo $response | jq -r '.Title')
year=$(echo $response | jq -r  '.Year')
release_date=$(echo $response | jq -r '.Released')
runtime=$(echo $response | jq -r '.Runtime')
Director=$(echo $response | jq -r '.Director')
actors=$(echo $response | jq -r '.Actors')
Box_office=$(echo $response | jq -r '.BoxOffice')
genres=$(echo $response | jq -r '.Genre')
poster=$(echo $response | jq -r '.Poster')

wget -P /home/aravindhan1891/spider_onsite_aug13/images "$poster"

backup_dir=/home/aravindhan1891/spider_onsite_aug13/movie_docker

ACTORS=()
while IFS="," read -ra names; do
    for i in "${names[@]}"; do
        ACTORS+=("{\"name\":\"$i\"}")
    done
done <<< "$actors"

DIRECTORS=()
while IFS="," read -ra names; do
    for i in "${names[@]}"; do
        DIRECTORS+=("{\"name\":\"$i\"}")
    done
done <<< "$Director"

GENRES=()
while IFS="," read -ra names; do
    for i in "${names[@]}"; do
        ACTORS+=("{\"name\":\"$i\"}")
    done
done <<< "$genres"

docker exec -i mongo1 mongo "$MONGO_HOST/$DATABASE" --eval "db.movies.insertOne({ title: '$Title', year: '$year', releaseDate: '$release_date', runtime: '$runtime', director: '$Director', actors: '$Actors', boxOffice: '$Box_office' })"

for actor in "${ACTORS[@]}";do
docker exec -i mongo1 mongo "$MONGO_HOST/$DATABASE" --eval "db.actors.insertOne({$actor})"
done

for director in "${DIRECTORS[@]}";do
docker exec -i mongo1 mongo "$MONGO_HOST/$DATABASE" --eval "db.Directors.insertOne({$director})"
done

for genre in "${GENRES[@]}";do
docker exec -i mongo1 mongo "$MONGO_HOST/$DATABASE" --eval "db.genres.insertOne({$genre})"
done

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

docker exec -i mongo1 mongodump --uri="$MONGO_HOST/$DATABASE" --collection="movies" --out="$backup_dir/$DATE"

(crontab -l 2>/dev/null ; echo "30 0 * * * /usr/bin/bash /home/aravindhan1891/spider_onsite_aug13/movie_docker/backup_movies.sh") | crontab -e


















