FROM alpine:3.3
MAINTAINER Nathaniel Ritholtz <nritholtz@gmail.com>

# Install required packages
RUN apk add --update \
  ca-certificates \
  ruby \
  ruby-bundler \
  ruby-irb \
  ruby-dev \
  && rm -fr /usr/share/ri

RUN apk add --update \
              build-base \
              bash \
              curl \      
              supervisor \           
  && rm -rf /var/cache/apk/*

# Install Fluentd
RUN gem install fluentd -v 0.12.20 --no-rdoc --no-ri && \
  fluent-gem install fluent-plugin-cloudwatch-logs -v 0.2.2 --no-rdoc --no-ri 

# Install docker-gen
RUN curl -J -L -o docker-gen.tar.gz https://github.com/jwilder/docker-gen/releases/download/0.7.0/docker-gen-alpine-linux-amd64-0.7.0.tar.gz && tar -C /usr/local/bin -xvzf docker-gen.tar.gz \
 && rm docker-gen.tar.gz

# Copy fluentd config file
COPY fluent.conf /etc/fluent/

ADD . /

EXPOSE 24224

CMD ["/bin/bash", "./bootstrap.sh"]
