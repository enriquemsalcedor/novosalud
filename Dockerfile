FROM ruby:2.3.3slim
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /comercializacion_web_novosalud
WORKDIR /comercializacion_web_novosalud
ADD Gemfile /comercializacion_web_novosalud/Gemfile
ADD Gemfile.lock /comercializacion_web_novosalud/Gemfile.lock
RUN bundle install
ADD . /comercializacion_web_novosalud
