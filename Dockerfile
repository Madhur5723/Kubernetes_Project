FROM centos

LABEL maintainer="vikash@gmail.com"

# Configure yum to use vault.centos.org for older CentOS versions
RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-*

# Install necessary packages
RUN yum -y install java httpd zip unzip && \
    yum clean all

# Download and add the zip file
RUN curl -o /var/www/html/photogenic.zip https://www.free-css.com/assets/files/free-css-templates/download/page254/photogenic.zip

# Unzip and set up the web files
WORKDIR /var/www/html/
RUN unzip -q photogenic.zip && \
    cp -rvf photogenic/* . && \
    rm -rf photogenic photogenic.zip

# Expose necessary ports
EXPOSE 80 22

# Start Apache in the foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
