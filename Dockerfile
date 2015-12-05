FROM codeclimate/alpine-ruby:b38

MAINTAINER Andy Waite
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN apk update
RUN apk add ruby ruby-dev ruby-bundler
RUN apk add build-base
RUN apk add git
RUN bundle install -j 4 && \
    apk del build-base && \
    rm -fr /usr/share/ri

RUN adduser -u 9000 -D app
RUN chown -R app:app /usr/src/app

WORKDIR /code
USER app

CMD ["/usr/src/app/bin/reek", "--format=code_climate", "/code"]
