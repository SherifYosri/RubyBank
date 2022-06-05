FROM ruby:2.7.2

ENV APP_HOME /BankingApp

# Installation of dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
    # The following are used to trim down the size of the image by removing unneeded data
  && apt-get clean autoclean && apt-get autoremove -y

# Create a directory for our application and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Add our Gemfile and install gems
ADD Gemfile* $APP_HOME/
RUN bundle install

# Copy over our application code
ADD . $APP_HOME

# Run our app
CMD bundle exec rails db:create db:migrate db:seed && bundle exec rails s -p 3000 -b '0.0.0.0'