docker-build:
        docker build --no-cache --pull -t ghcr.io/splinterstice/splinterstice:latest \
                -f docker/Dockerfile .

docker-push:
        docker push ghcr.io/splinterstice/splinterstice:latest
