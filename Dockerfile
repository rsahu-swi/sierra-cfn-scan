FROM ubuntu:22.04

RUN apt update && apt-get install -y  --no-install-recommends \
        python3 \
        python3-pip \
        ruby \
        && gem install cfn-nag \
        && rm -rf /var/lib/apt/lists/*  

# Creating user with name "cfn"
RUN groupadd -r cfn && useradd --no-log-init -r -g cfn cfn

USER cfn
WORKDIR /home/cfn

RUN pip3 install --no-cache-dir -U checkov cfn-lint requests --user

ENV PATH="$PATH:/home/cfn/.local/bin"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
