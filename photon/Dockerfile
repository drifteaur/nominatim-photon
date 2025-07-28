FROM openjdk:11-jre

WORKDIR /photon
ADD https://github.com/komoot/photon/releases/download/0.7.2/photon-opensearch-0.7.2.jar /photon/photon.jar
COPY entrypoint.sh ./entrypoint.sh

EXPOSE 2322

ENTRYPOINT /photon/entrypoint.sh
