# FROM python:3.8-alpine

# RUN python3 -m pip install --upgrade pip



# an explicitly blank version appears to grab latest
# override here for a real build process
ARG version=''

FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

# FROM ruby:2.7-alpine

ENV RUN_IN_DOCKER=True

RUN set -eux; \
    apt update; \
    apt -y --no-install-recommends upgrade; \
    apt install -y --no-install-recommends \
            ca-certificates \
            git \
            curl \
            python3 \
            openssh-client \
    ;  
RUN curl -sSLo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3; \
    chmod 700 get_helm.sh; \
    VERIFY_CHECKSUM=true ./get_helm.sh; \
    rm ./get_helm.sh; \
    \
    curl -sSLo get_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh; \
    chmod 700 get_kustomize.sh; \
    ./get_kustomize.sh; mv /kustomize /usr/bin/kustomize; \
    rm ./get_kustomize.sh; 
RUN apt install -y apt-transport-https gnupg2
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN source /usr/local/rvm/scripts/rvm
RUN python3 -m pip install --upgrade pip
    # \
    # apt remove -y curl; \
    # apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    # rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -U checkov

RUN pip install cfn-lint
RUN pip install pydot

RUN gem install cfn-nag --version "$version"

ENTRYPOINT ["tail", "-f", "/dev/null"]



# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
