FROM prantlf/alpine-glibc
LABEL maintainer="Ferdinand Prantl <prantlf@gmail.com>"

RUN apk --no-cache add git git-fast-import python3 vim && \
	wget -q -O /usr/bin/git-p4.py https://raw.githubusercontent.com/git/git/v2.38.1/git-p4.py && \
	wget -q -O /usr/bin/p4 https://cdist2.perforce.com/perforce/r22.1/bin.linux26x86_64/p4 && \
  sed -i 's#/usr/bin/env python#/usr/bin/env python3#' /usr/bin/git-p4.py && \
	chmod a+x /usr/bin/git-p4.py /usr/bin/p4
COPY . /
ENV P4CLIENT P4CONFIG P4PASSWD P4PORT P4USER
