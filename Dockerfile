FROM docker.pkg.github.com/haruelico/imagemagick-docker/imagemagick:6-latest
FROM ruby:2.7.1-buster
WORKDIR /src/image-minifier
ENV PORT=8000

COPY --from=0 /usr/local/bin /usr/local/bin/
COPY --from=0 /usr/local/lib /usr/local/lib/
COPY --from=0 /usr/local/etc/ImageMagick-6 /usr/local/etc/ImageMagick-6/
RUN ldconfig /usr/local/lib
RUN ruby -v
RUN convert --version
COPY Gemfile Gemfile.lock /src/image-minifier/
RUN bundle install
COPY . .
CMD bundle exec ruby server.rb -p $PORT -o 0.0.0.0