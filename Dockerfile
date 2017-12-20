FROM jenkins/jenkins:lts


#####################
# SET ENV VARIALBES #
#####################
# ENV JMETER_PATH=~jmeter\
#    JMETER_VERSION=0.12.4

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

####################
# GET DEPENDENCIES #
####################

# Update the environment
USER root
RUN set -xe;
RUN apt-get update
RUN apt-get -y upgrade

# Install JDK. Required by jmeter
RUN cd /tmp
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz
RUN tar -zxvf jdk-8u*-linux-*.tar.gz
RUN mv jdk1.8.*/ /usr/
RUN update-alternatives --install /usr/bin/java java /usr/jdk1.8.*/bin/java 2
RUN update-alternatives --set java /usr/jdk1.8.0_151/bin/java

#Download jmeter
RUN cd /tmp
RUN wget --no-check-certificate --no-cookies http://www-eu.apache.org/dist/jmeter/binaries/apache-jmeter-3.3.tgz
RUN tar -zxvf apache-jmeter-3.3.tgz
RUN mv apache-jmeter-3.3 /var/
RUN chown -R jenkins:jenkins /var/apache-jmeter-3.3

# Copy groovy to create a user.
COPY createUser.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
# Copy groovy to create initial project (job/item)
COPY createProject.groovy /usr/share/jenkins/ref/init.groovy.d/project.groovy

# Install plugins
RUN /usr/local/bin/install-plugins.sh performance github-branch-source:latest

# make jenkins the owner of var
RUN chown -R jenkins /var/jenkins_home/

USER jenkins