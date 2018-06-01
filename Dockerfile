#Requirements to install jira with MYSQL
  #JIRA 7.0.4
  #Ubuntu 14.04 Server
  #MySQL 5.6.27
  #JDBC Driver : mysql-connector-java-5.1.38-bin.jar

FROM ubuntu:14.04
MAINTAINER Vinay <vnydevops@gmail.com>

ENV JIRA_HOME=/var/atlassian/jira
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle

EXPOSE 8080

# Creating JIRA home directory
RUN mkdir -p                "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_HOME}/caches/indexes" \
    && chmod -R 700            "${JIRA_HOME}"

# Installing JAVA-8
RUN apt-get update \
  && apt-get -y install software-properties-common \
  && add-apt-repository ppa:webupd8team/java \
  && apt-get update \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
  && apt-get -y install oracle-java8-installer \
  && apt-get clean autoclean -y \
  && echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment

# Installing JIRA 
RUN mkdir --p /opt/atlassian \
    && chmod -R 700 /opt/atlassian \ 
    && cd /opt/atlassian \
    && apt-get install -y wget \
    && wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.0.4-jira-7.0.4.tar.gz \
    && tar -xvzf atlassian-jira-software-7.0.4-jira-7.0.4.tar.gz \
    && mv atlassian-jira-software-7.0.4-standalone /opt/atlassian/jira \
    && cd /opt/atlassian/jira/bin
ADD ./init.sh /init.sh

# Installing mysql-connector-java in jira
RUN cd /opt/atlassian/jira/lib \
  && wget https://cdn.mysql.com//archives/mysql-connector-java-5.1/mysql-connector-java-5.1.35.tar.gz \
  && tar -xvzf mysql-connector-java-5.1.35.tar.gz \
  && rm -rf mysql-connector-java-5.1.35.tar.gz \
  && cp /opt/atlassian/jira/lib/mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar /opt/atlassian/jira/lib/ \
  && rm -rf  /opt/atlassian/jira/lib/mysql-connector-java-5.1.35


CMD ["sh", "/init.sh"]
