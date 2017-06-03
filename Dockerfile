FROM centos:7

# Setup args
ARG JDK_VERSION=u131
ARG JDK_RPM=jdk-8$JDK_VERSION-linux-x64.rpm
ARG JDK_URL=http://download.oracle.com/otn-pub/java/jdk/8$JDK_VERSION-b11/d54c1d3a095b4ff2b6607d096fa80163/$JDK_RPM
ARG JIRA_VERSION=7.3.6
ARG JIRA_TAR=atlassian-jira-software-$JIRA_VERSION.tar.gz
ARG JIRA_URL=https://www.atlassian.com/software/jira/downloads/binary/$JIRA_TAR

# Configure environment variables
ENV JIRA_ROOT /opt/atlassian/jira/current
ENV JIRA_HOME /var/lib/atlassian/jira
ENV JAVA_HOME /usr/java/default

# Install required packages
RUN yum update -y \
    && yum clean all \
    && yum install -y \
        sudo \
        wget \
        vim \
        git \
        docker \
    && yum clean all

# Install Oracle JDK
RUN cd /tmp \
    && wget --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL \
    && yum localinstall -y $JDK_RPM \
    && rm /tmp/$JDK_RPM

# Unpack JIRA software into installation directory
RUN mkdir -p $JIRA_ROOT \
    && mkdir -p $JIRA_HOME \
    && cd $JIRA_ROOT \
    && wget $JIRA_URL \
    && tar -xzf $JIRA_ROOT/$JIRA_TAR --strip-components=1 -C $JIRA_ROOT

# Create dedicated JIRA user
RUN /usr/sbin/useradd --create-home --comment "Account for running JIRA Software" --shell /bin/bash jira; \
    chown -R jira $JIRA_ROOT/..; \
    chmod -R u=rwx,go-rwx $JIRA_ROOT/..

RUN cd $JIRA_ROOT/bin \
    && sed -i "s|#JIRA_HOME=\"\"|JIRA_HOME=${JIRA_HOME}|g" setenv.sh

ENTRYPOINT sudo -u jira $JIRA_ROOT/bin/setenv.sh && $JIRA_ROOT/bin/start-jira.sh -fg
