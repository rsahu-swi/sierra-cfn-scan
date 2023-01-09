FROM ubuntu:22.04

RUN apt-get update && apt-get install -y  --no-install-recommends \
        python3 \
        python3-pip \
        ruby \
        && gem install cfn-nag \
        && rm -rf /var/lib/apt/lists/*  

RUN pip3 install checkov cfn-lint requests --user

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
