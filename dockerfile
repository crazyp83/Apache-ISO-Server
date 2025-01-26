FROM httpd:2.4
#COPY ./public-html/ /usr/local/apache2/htdocs/
VOLUME /var/www/html/iso
COPY iso.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/iso.sh
RUN /usr/local/bin/iso.sh
