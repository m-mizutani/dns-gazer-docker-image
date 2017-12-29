FROM alpine:3.7
RUN apk update
RUN apk add --no-cache libpcap libpcap-dev msgpack-c msgpack-c-dev
RUN mkdir /opt/
WORKDIR /opt/

RUN rm -rf lib bin CMakeCache.txt CMakeFiles
RUN apk add --no-cache --virtual .build-deps git cmake clang automake alpine-sdk && \
		git clone --recursive https://github.com/m-mizutani/dns-gazer.git && \
		cd dns-gazer && \
		cmake . && \
		make install && \
		apk del .build-deps && \
		rm -rf /opt/dns-gazer
RUN apk add libstdc++
CMD /usr/local/bin/dns-gazer -i $NIC -f $LOG_DST
