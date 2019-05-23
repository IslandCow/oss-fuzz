FROM gcr.io/oss-fuzz-base/base-builder
MAINTAINER skau@chromium.org
RUN apt-get update && apt-get install -y libgnutls-dev liblcms2-dev
RUN git clone https://github.com/apple/cups.git cups
WORKDIR cups
RUN mkdir $SRC/fuzz
COPY cups_ppdopen_fuzzer.cc $SRC/fuzz
COPY build.sh $SRC/
