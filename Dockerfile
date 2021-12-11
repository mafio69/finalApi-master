FROM mafio69/php-debian:v8.1.0

WORKDIR /

ENV DEBIAN_FRONTEND=noninteractive \
    APP_ENV=${APP_ENV:-dev} \
    XDEBUG_MODE=${XDEBUG_MODE:-off}

RUN  mkdir -p /var/log/cron/ \
    	&& mkdir -p /usr/share/nginx/logs/ \
    	&& mkdir -p /var/log/nginx/ \
    	&& mkdir -p /var/lib/nginx/body \
    	&& chmod 777 -R /var/lib/nginx/ \
    	&& chmod 777 -R /var/log/ \
        && usermod -a -G docker root && adduser \
       --system \
       --shell /bin/bash \
       --disabled-password \
       --home /home/docker \
       docker \
       && usermod -a -G docker root \
       && usermod -a -G docker docker \
       && rm -f /etc/supervisor/conf.d/supervisord.conf \
       && touch -c /var/log/cron/cron.log \
       && touch -c /usr/share/nginx/logs/error.log# COPY container.d/xdebug-on.ini /usr/local/etc/php/conf.d/xdebug.ini

# ADD --chown=docker:docker /main /main
COPY container.d/cron-task /etc/cron.d/crontask
COPY container.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

STOPSIGNAL SIGQUIT

WORKDIR /main

EXPOSE 8080

STOPSIGNAL SIGQUIT

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisord.conf"]



