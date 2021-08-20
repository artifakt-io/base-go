FROM registry.artifakt.io/golang:1.16

ARG CODE_ROOT=.

COPY --chown=www-data:www-data $CODE_ROOT /var/www/html

RUN if [ -f go.mod ]; then go get -d -v ./...; fi
RUN if [ -f go.mod ]; then go install -v ./...; fi
RUN go build -v || true

# copy the artifakt folder on root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN  if [ -d .artifakt ]; then cp -rp /var/www/html/.artifakt /.artifakt/; fi

# run custom scripts build.sh
# hadolint ignore=SC1091
RUN --mount=source=artifakt-custom-build-args,target=/tmp/build-args \
  if [ -f /tmp/build-args ]; then source /tmp/build-args; fi && \
  if [ -f /.artifakt/build.sh ]; then /.artifakt/build.sh; fi
