FROM ruby:3.4.2

RUN apt-get update && apt-get install -y nodejs yarn default-mysql-client redis-tools

RUN mkdir /app
WORKDIR /app
COPY splinterstice/Gemfile Gemfile
COPY splinterstice/Gemfile.lock Gemfile.lock 
RUN gem install bundler
RUN bundle install
COPY splinterstice .

RUN rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
