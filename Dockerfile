FROM alpine:latest
WORKDIR /tmp

RUN apk add git nano zip && \
echo @testing http://dl-cdn.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories && \
apk update && \
apk add ca-certificates mono@testing && \
cert-sync /etc/ssl/certs/ca-certificates.crt && \
wget https://github.com/athendrix/Bridge/releases/download/v17.10.1/bridge-cli.17.10.1.zip && \
unzip bridge-cli.17.10.1.zip -d /opt && \
rm -R /tmp/* && \
echo "#!/bin/sh" > /usr/local/bin/bridge && \
echo "mono /opt/bridge-cli.17.10.1bridge.exe \"\${@}\"" >> /usr/local/bin/bridge && \
echo "exit \${?}" >> /usr/local/bin/bridge && \
chmod +x /usr/local/bin/bridge

WORKDIR /home/bridge/projects/template
RUN bridge new                              && \
bridge add package Bridge.HTML5             && \
bridge add package Bridge.HTML5.Console     && \
bridge add package Bridge.Newtonsoft.JSON   && \
bridge restore                              && \
bridge build
WORKDIR /home/bridge/projects
