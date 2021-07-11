ARG UBUNTU_VERSION=20.04

FROM ubuntu:$UBUNTU_VERSION AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY . /RelaxMap

WORKDIR /RelaxMap

RUN make distclean

RUN make

FROM ubuntu:${UBUNTU_VERSION}

RUN apt-get update && apt-get install -y \
        libgomp1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /RelaxMap

COPY --from=builder /RelaxMap/ompRelaxmap /RelaxMap

VOLUME /data

WORKDIR /data

ENTRYPOINT ["/RelaxMap/ompRelaxmap"]
CMD ["--help"]
