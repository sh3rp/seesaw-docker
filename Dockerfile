#
# Seesaw Dockerfile
#

FROM debian:latest

RUN apt-get -y update && apt-get upgrade -y && apt-get autoclean
RUN apt-get -y install libnl-3-dev libnl-genl-3-dev build-essential git wget
RUN cd /usr/local && wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz && tar xvfz go1.7.3.linux-amd64.tar.gz
RUN mkdir /opt/go
ENV GOPATH=/opt/go
ENV PATH /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:/usr/local/seesaw
RUN go get -u golang.org/x/crypto/ssh
RUN go get -u github.com/dlintw/goconf
RUN go get -u github.com/golang/glog
RUN go get -u github.com/miekg/dns
RUN go get -u github.com/kylelemons/godebug/pretty
RUN go get -u github.com/golang/protobuf/proto
RUN mkdir -p ${GOPATH}/src/github.com/google
RUN cd ${GOPATH}/src/github.com/google && git clone https://github.com/google/seesaw
RUN cd ${GOPATH}/src/github.com/google/seesaw && make test && make install
RUN mkdir -p /usr/local/seesaw
RUN cp ${GOPATH}/bin/seesaw_* /usr/local/seesaw
#RUN sh /opt/install_seesaw.sh
ADD seesaw_watchdog.service /etc/systemd/system/
RUN mkdir -p /etc/seesaw
ADD watchdog.cfg /etc/seesaw/
ADD seesaw.cfg /etc/seesaw/
