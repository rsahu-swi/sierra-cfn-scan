FROM python:3.8-alpine

RUN python3 -m pip install --upgrade pip

RUN pip install cfn-lint
RUN pip install pydot


FROM ruby:2.7-alpine

# an explicitly blank version appears to grab latest
# override here for a real build process
ARG version=''

RUN gem install cfn-nag --version "$version"

FROM python:3.8-slim

ENV RUN_IN_DOCKER=True

RUN set -eux; \
    apt-get update; \
    apt-get -y --no-install-recommends upgrade; \
    apt-get install -y --no-install-recommends \
            ca-certificates \
            git \
            curl \
            openssh-client \
    ; 
   
    curl -sSLo get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3; \
    chmod 700 get_helm.sh; \
    VERIFY_CHECKSUM=true ./get_helm.sh; \
    rm ./get_helm.sh; \
    \
    curl -sSLo get_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh; \
    chmod 700 get_kustomize.sh; \
    ./get_kustomize.sh; mv /kustomize /usr/bin/kustomize; \
    rm ./get_kustomize.sh; \
    \
    apt-get remove -y curl; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -U checkov

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
