docker-build:
        docker build --pull -t ghcr.io/splinterstice/splinterstice:latest \
                -f docker/Dockerfile .

docker-push:
        docker push ghcr.io/splinterstice/splinterstice:latest
