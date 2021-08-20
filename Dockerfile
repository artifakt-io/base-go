FROM registry.artifakt.io/golang:1.16

ARG CODE_ROOT=.

COPY --chown=www-data:www-data $CODE_ROOT /var/www/html

RUN env

RUN ls -la /var/www/html && ls -la /go/src/app


RUN if [ -f go.mod ]; then go get -d -v ./...; fi
RUN if [ -f go.mod ]; then go install -v ./...; fi
RUN go build -v

# copy the artifakt folder on root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN  if [ -d .artifakt ]; then cp -rp /var/www/html/.artifakt /.artifakt/; fi

# run custom scripts build.sh
# hadolint ignore=SC1091
#RUN --mount=source=artifakt-custom-build-args,target=/tmp/build-args \
RUN if [ -f /tmp/build-args ]; then source /tmp/build-args; fi && \
  if [ -f /.artifakt/build.sh ]; then /.artifakt/build.sh; fi

#ENV CUSTOM_ENTRYPOINT_BINARY=/var/www/html/app
#RUN echo ${CUSTOM_ENTRYPOINT_BINARY} >> /var/www/html/app
#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
#CMD ["app"]
