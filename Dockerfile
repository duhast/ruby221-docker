FROM ubuntu:18.04

ENV RUBY_MAJOR=2.2
ENV RUBY_VERSION=2.2.1
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update -qq
RUN apt-get install -y bison libgdbm-dev ruby openssl curl autoconf bison build-essential libssl1.0-dev libyaml-dev \
    libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libdb-dev
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/src/ruby
RUN curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" | tar -xjC /usr/src/ruby --strip-components=1

WORKDIR /usr/src/ruby
RUN autoconf
RUN ./configure --disable-install-doc
RUN make -j"$(nproc)"
RUN make install
RUN apt-get purge -y --auto-remove bison libgdbm-dev ruby
RUN rm -r /usr/src/ruby

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler -v=1.17.3
RUN bundle config --global path "$GEM_HOME" && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

WORKDIR /

CMD [ "irb" ]
