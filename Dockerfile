FROM ruby:2.6.1

RUN apt-get update && \
apt-get install apt-transport-https

RUN curl -fsSL https://deb.nodesource.com/setup_13.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
apt-get install -y mariadb-client nodejs yarn vim --no-install-recommends && \
rm -rf /var/lib/apt/lists/*

RUN mkdir /rails_app

WORKDIR /rails_app

ADD Gemfile /rails_app/Gemfile
ADD Gemfile.lock /rails_app/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /rails_app
