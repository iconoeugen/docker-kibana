FROM centos:7

RUN yum install -y epel-release && \
    yum -y install nss_wrapper && \
    yum clean all

ENV USER kibana
ENV HOME /opt/kibana
ENV PATH /opt/kibana/bin:$PATH
ENV KIBANA_VERSION 4.5.4-1

COPY kibana.repo /etc/yum.repos.d/kibana.repo
RUN yum -y install kibana-${KIBANA_VERSION} && \
    yum clean all

COPY passwd.in ${HOME}/
COPY entrypoint /

RUN for path in /opt/kibana ; do \
      chmod -R ug+rwX "${path}" && chown -R $USER:root "${path}"; \
    done

EXPOSE 5601
USER 1000

ENTRYPOINT ["/entrypoint"]
CMD ["kibana"]
