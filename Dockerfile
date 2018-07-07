FROM ubuntu:16.04
MAINTAINER mitsu9 mitsu9@mitsu9.com 

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install curl git gcc build-essential libssl-dev libreadline-dev zlib1g-dev -y && \
    git clone https://github.com/rbenv/rbenv.git /root/.rbenv && \
    cd /root/.rbenv && src/configure && make -C src && \
    git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
ENV PATH "/root/.rbenv/bin:$PATH"
RUN echo 'export PATH="/root/.rbenv/bin:$PATH"' >> ~/.bash_profile && \
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile && \
    rbenv install 2.3.3 && \
    rbenv global 2.3.3 && \
    rbenv rehash

WORKDIR /home/hawkeye-bot
ADD . /home/hawkeye-bot
RUN eval "$(rbenv init -)" && \
    gem install bundler && \
    bundle install --path vendor/bundle
CMD [ "/bin/bash" ]
