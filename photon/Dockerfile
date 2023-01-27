FROM openjdk:8-jre

WORKDIR /photon
ADD https://github.com/komoot/photon/releases/download/0.4.2/photon-0.4.2.jar /photon/photon.jar
COPY entrypoint.sh ./entrypoint.sh

EXPOSE 2322

ENTRYPOINT /photon/entrypoint.sh
