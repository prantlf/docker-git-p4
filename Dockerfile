FROM prantlf/alpine-glibc:latest
LABEL maintainer="Ferdinand Prantl <prantlf@gmail.com>"

RUN apk --no-cache add git git-fast-import python2 vim && \
	wget -O /usr/bin/git-p4.py https://raw.githubusercontent.com/git/git/v2.26.2/git-p4.py && \
	wget -O /usr/bin/p4 http://cdist2.perforce.com/perforce/r20.1/bin.linux26x86_64/p4 && \
	chmod a+x /usr/bin/git-p4.py /usr/bin/p4
COPY . /
ENV P4CLIENT P4CONFIG P4PASSWD P4PORT P4USER
