ARG FRM='testdasi/openvpn-nzb-hysasora-base'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

ADD scripts /

RUN /bin/bash /install.sh \
    && rm -f /install.sh

VOLUME ["/config", "/data"]

ENTRYPOINT ["/entrypoint.sh"]

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info
