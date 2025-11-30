FROM debian:13
WORKDIR /src
RUN apt update && apt install build-essential -y
RUN apt install git texinfo install-info -y
RUN apt install npm -y
RUN npm install -g http-proxy-to-socks
RUN git clone https://github.com/jech/polipo.git && cd polipo
RUN cd /src/polipo && make && make install &&\
    mkdir -p /var/log/polipo
RUN apt install tor sudo ncat haproxy privoxy -y
RUN cd /opt && git clone https://github.com/trimstray/multitor
RUN chmod +x /opt/multitor/bin/multitor 
RUN cd /opt/multitor && /bin/bash ./setup.sh install
RUN cd /opt/multitor && sed -i 's/127.0.0.1:16379/0.0.0.0:16379/g' templates/haproxy-template.cfg
COPY ./runmt .
#RUN chown -R debian-tor /var/lib/multitor


#remove before push
RUN apt install curl sockstat -y
ENV TOR_INSTANCES=2
ENV MT_SOCKS_PORT=9000
ENV MT_CTRL_PORT=9900
ENV MT_PROXY=privoxy
#CMD ["/bin/bash"]
EXPOSE 16379
CMD ["/bin/bash", "/src/runmt"]
