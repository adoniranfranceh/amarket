FROM ruby:3.0.0

RUN gem install bundler:2.4.13
RUN bundle config --global frozen 1
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN yarn install
EXPOSE 3000
