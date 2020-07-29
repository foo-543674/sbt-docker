FROM openjdk:13-jdk-alpine3.10

ARG SBT_VER="1.3.10" 
ARG SBT_URL="https://piccolo.link/sbt-${SBT_VER}.tgz"
ARG SBT_ESUM="3060065764193651aa3fe860a17ff8ea9afc1e90a3f9570f0584f2d516c34380"

RUN apk update && \
    apk add --no-cache bash && \    
    apk add --no-cache --virtual=.build-dependencies \
      curl && \
    #sbt
    curl -Ls "${SBT_URL}" > "/tmp/sbt-${SBT_VER}.tgz" && \ 
    sha256sum "/tmp/sbt-${SBT_VER}.tgz" && \
    (echo "${SBT_ESUM}  /tmp/sbt-${SBT_VER}.tgz" | sha256sum -c -) && \
    tar -zxf "/tmp/sbt-${SBT_VER}.tgz" -C "/opt" && \
    rm -rf "/tmp/"* && \
    apk del .build-dependencies

ENV PATH="/opt/sbt/bin:$PATH" \
    JAVA_OPTS="-XX:+UseContainerSupport -Dfile.encoding=UTF-8" \
    SBT_OPTS="-Xmx2048M -Xss2M"

WORKDIR "/var/tmp"
ENTRYPOINT [ "sbt" ]