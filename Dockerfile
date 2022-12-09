FROM ubuntu:20.04
RUN apt update && apt-get install -y \
        python3 \
        python3-pip \
        ruby-full \
        rubygems
RUN pip3 install --no-cache-dir -U checkov cfn-lint
RUN pip3 install --upgrade requests
RUN gem install cfn-nag

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
