FROM quay.io/getpantheon/debian:jessie
ENV LSB_RELEASE jessie

ENV DOCKER_VERSION 18.03.0~ce-0~debian
ENV FETCH_URL https://github.com/gruntwork-io/fetch/releases/download/v0.1.0/fetch_linux_amd64

# need apt-transport-https and curl installed before configuring google's apt repo
RUN apt-get update -qq \
    && apt-get install -qy \
        curl \
        jq \
        apt-transport-https \
        make \
        openssh-client \
        ca-certificates \
    && apt-get upgrade -qy \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*


# install gcloud apt repo, google-cloud-sdk, kubectl, docker-ce apt repo, docker-ce, and fetch
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-${LSB_RELEASE} main" \
        | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
        && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
        && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
        && curl -s -L $FETCH_URL -o /bin/fetch \
        && chmod 755 /bin/fetch \
        && echo \
        "deb [arch=amd64] https://download.docker.com/linux/debian ${LSB_RELEASE} stable" \
        > /etc/apt/sources.list.d/docker.list \
    && apt-get update -qq \
    && apt-get install -qy \
        google-cloud-sdk \
        kubectl \
        docker-ce=$DOCKER_VERSION \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

