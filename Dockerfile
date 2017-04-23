FROM google/golang:stable
MAINTAINER Mahmoud Ben Hassine <mahmoud.benhassine@icloud.com>
RUN mkdir -p $GOPATH/src/gossed
WORKDIR $GOPATH/src/gossed
RUN go get github.com/alexandrevicenzi/go-sse
COPY gossed.go .
RUN go install
EXPOSE 3000
CMD ["gossed"]
