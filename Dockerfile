ARG ALPINE_VERSION=3.14

FROM alpine:$ALPINE_VERSION AS builder

RUN apk add --no-cache build-base

COPY . /RelaxMap

WORKDIR /RelaxMap

RUN make distclean

RUN make

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
        libgcc \
        libstdc++ \
        libgomp

RUN mkdir /RelaxMap

COPY --from=builder /RelaxMap/ompRelaxmap /RelaxMap

VOLUME /data

WORKDIR /data

ENTRYPOINT ["/RelaxMap/ompRelaxmap"]
CMD ["--help"]
