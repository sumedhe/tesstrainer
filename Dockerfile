#
# Docker image for compiling Tesseract 4 (and Leptonica) from source code.
# Includes SSH Server (root password is root).
# https://github.com/tesseract-ocr/tesseract/wiki/Compiling#linux
# http://www.leptonica.org/source/README.html
#

FROM ubuntu

RUN apt-get update && apt-get install -y \
	autoconf \
	autoconf-archive \
	automake \
	build-essential \
	checkinstall \
	cmake \
	g++ \
	git \
	libcairo2-dev \
	libcairo2-dev \
	libicu-dev \
	libicu-dev \
	libjpeg8-dev \
	libjpeg8-dev \
	libpango1.0-dev \
	libpango1.0-dev \
	libpng12-dev \
	libpng12-dev \
	libtiff5-dev \
	libtiff5-dev \
	libtool \
	pkg-config \
	wget \
	xzgv \
	zlib1g-dev


# SSH for diagnostic
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Directories
ENV BASE_DIR        /tesstrainer
ENV SRC_DIR         ${BASE_DIR}/src
ENV SCRIPTS_DIR     ${BASE_DIR}/scripts
ENV WORKSPACE_DIR   ${BASE_DIR}/workspace
ENV LEP_REPO_URL    https://github.com/DanBloomberg/leptonica.git
ENV LEP_SRC_DIR     ${SRC_DIR}/leptonica
ENV TES_REPO_URL    https://github.com/sumedhe/tesseract.git
ENV TES_SRC_DIR     ${SRC_DIR}/tesseract
ENV TESSDATA_PREFIX /usr/local/share/tessdata
ENV LANGDATA_DIR    ${BASE_DIR}/langdata
ENV FONTS_DIR       /usr/local/share/fonts

RUN mkdir -p ${BASE_DIR}
RUN mkdir -p ${SRC_DIR}
RUN mkdir -p ${SCRIPTS_DIR}
RUN mkdir -p ${FONTS_DIR}
RUN mkdir -p ${LANGDATA_DIR}
RUN mkdir -p ${TESSDATA_PREFIX}

COPY ./container-files/scripts   ${SCRIPTS_DIR}/
COPY ./container-files/fonts     ${FONTS_DIR}/
COPY ./container-files/langdata  ${LANGDATA_DIR}/
RUN chmod +x ${SCRIPTS_DIR}/*

RUN ${SCRIPTS_DIR}/repos_clone.sh
RUN ${SCRIPTS_DIR}/tessdata_download.sh

WORKDIR /tesstrainer
