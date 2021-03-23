FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs
# yarnパッケージ管理ツールをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y nodejs yarn

RUN mkdir /docker-ruby-template
WORKDIR /docker-ruby-template
COPY Gemfile /docker-ruby-template/Gemfile
COPY Gemfile.lock /docker-ruby-template/Gemfile.lock
RUN bundle install
COPY . /docker-ruby-template

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]