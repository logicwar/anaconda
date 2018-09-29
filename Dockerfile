FROM osixia/light-baseimage:1.1.1

#########################################
##             SET LABELS              ##
#########################################

# set version and maintainer label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Logicwar <logicwar@gmail.com>"


#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set default environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    DUID=1001 DGID=1001 \
    LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    PATH=/opt/conda/bin:$PATH

#########################################
##          DOWNLOAD PACKAGES          ##
#########################################

# Download and install Dependencies
RUN \
 echo "**** Install Dependencies ****" && \
 apt-get update && \
 apt-get install --no-install-recommends -y \
	wget \
	curl \
	bzip2 \
	ca-certificates \
	libglib2.0-0 \
	libxext6 \
	libsm6 \
	libxrender1 \
	unzip \
	git \
	vim && \
 echo "**** Install cron service ****" && \
 /container/tool/add-service-available :cron && \
 rm -rf \
	/var/lib/apt/lists/* \	
	/tmp/* \
	/var/tmp/*

# Download and install Main Software
RUN \
 echo "**** Install Anaconda3-5.2.0  ****" && \
 wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
 /bin/bash ~/anaconda.sh -b -p /opt/conda && \
 rm ~/anaconda.sh && \
 ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
 echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
 echo "conda activate base" >> ~/.bashrc && \
 echo "**** cleanup ****" && \
 apt-get clean


#########################################
##       COPY & RUN SETUP SCRIPT       ##
#########################################
# copy setup, default parameters and init files
COPY service /container/service

# set permissions and run install-service script
RUN \
 chmod -R +x /container/service && \
 /container/tool/install-service


#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

EXPOSE 8888
VOLUME /mnt/data

