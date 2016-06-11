# Community Edition Docker image on Ubuntu and JDK 7
# The base image contains glibc, which is required for the Java Service wrapper that is used by Mule ESB.
#
FROM emooti/tutorbase

MAINTAINER Uta Kapp "uta.kapp@emooti.org"

# Mule ESB CE version number.
ENV MULE_VERSION=3.8.0
ENV MULE_DOWNLOAD_URL=https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz
# Mule home directory in Docker image.
ENV MULE_HOME=/opt/mule-standalone \

# environment variable to true to set timezone on container start.
     CONTAINER_TIMEZONE=true \
# Default container timezone.
    CONTAINER_TIMEZONE=Europe/Stockholm

# Create the /opt directory in which software in the container is installed.
    RUN mkdir -p /opt && \
    cd /opt && \
# Create directory used by NTPD.
    mkdir -p /var/empty && \
# Install Mule ESB.
    wget ${MULE_DOWNLOAD_URL} && \
    tar xvzf mule-standalone-*.tar.gz && \
    rm mule-standalone-*.tar.gz && \
    mv mule-standalone-* mule-standalone

# Copy the script used to launch Mule ESB when a container is started.
# COPY ./start-mule.sh /opt/
# Copy configuration files to Mule ESB configuration directory.
# COPY ./conf/*.* ${MULE_HOME}/conf/

# Make the start-script executable.
# RUN chmod +x /opt/start-mule.sh && \
# Set the owner of all Mule-related files to the user which will be used to run Mule.
##    chown -R ${RUN_AS_USER}:${RUN_AS_USER} ${MULE_HOME} && \

# WORKDIR ${MULE_HOME}

# Default when starting the container is to start Mule ESB.
CMD [ "/bin/sh", "/opt/mule-standalone/bin/mule" ]

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Default http port
EXPOSE 8081
# JMX port.
EXPOSE 1099
--
