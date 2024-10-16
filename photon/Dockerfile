FROM openjdk:8-jre

WORKDIR /photon
ADD https://github.com/komoot/photon/releases/download/0.5.0/photon-0.5.0.jar /photon/photon.jar
COPY entrypoint.sh ./entrypoint.sh

EXPOSE 2322

ENTRYPOINT /photon/entrypoint.sh
