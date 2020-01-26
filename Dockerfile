FROM websphere-liberty:webProfile7
# use webspgere as open-liberty:open-liberty doesn't have apt-get/yum as of 2020/Jan
USER root
RUN apt-get update && apt-get -y install maven default-jdk

ENV BUILDER_VERSION 0.0.1
# point JDK for maven build
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

LABEL io.k8s.description="WAS Liberty S2I Image" \
      io.k8s.display-name="WAS Liberty S2I Builder" \
      io.openshift.tags="builder,was-liberty,javaee,microprofile" \
      io.openshift.s2i.scripts-url=image:///usr/local/s2i \
      io.s2i.scripts-url=image:///usr/local/s2i \
      io.openshift.expose-services="9080/tcp:http, 9443/tcp:https" \
      io.openshift.tags="runner,was-builder,liberty" \
      io.openshift.s2i.destination="/tmp"


COPY --chown=1001:0 ./.s2i/bin/ /usr/local/s2i
RUN chmod 775 /usr/local/s2i/*

COPY ./pom.xml     /
COPY ./nexus-settings.xml     /
RUN mkdir target
RUN chmod 777 target

ADD src/ /src/

USER 1001
