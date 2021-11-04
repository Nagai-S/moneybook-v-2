FROM ruby:2.6.1

RUN apt-get update && \
  apt-get install apt-transport-https

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
  
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN apt-get update && \
  apt-get install -y mariadb-client nodejs yarn vim --no-install-recommends google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

RUN wget https://chromedriver.storage.googleapis.com/90.0.4430.24/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/bin/

RUN mkdir /rails_app

WORKDIR /rails_app

ADD Gemfile /rails_app/Gemfile
ADD Gemfile.lock /rails_app/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /rails_app
