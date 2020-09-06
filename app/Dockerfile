FROM php:7.2-apache

ENV DEBIAN_FRONTEND=noninteractive

ENV DEST_DIR=/var/www/dtapi
ENV API_DIR=${DEST_DIR}/api
ENV APP_DIR=${API_DIR}/application

RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt update && apt install -y --no-install-recommends git && \
	apt install -y --no-install-recommends libapache2-mod-php php-mysql \
	php-mbstring php-gd php-pdo php-xml php-cli php-curl php-http php-json && \
	git clone https://github.com/koseven/koseven.git && \
	git clone https://github.com/yurkovskiy/dtapi.git && \
	mkdir -p ${API_DIR} && \
	cp -r koseven/system ${API_DIR} && \
	cp -r koseven/modules ${API_DIR} && \
	cp koseven/public/index.php ${API_DIR} && \
	cp -r dtapi/application ${API_DIR} && \
	cp -r dtapi/.htaccess ${API_DIR} && \
	mkdir ${APP_DIR}/cache ${APP_DIR}/logs && \
	chown -R www-data:www-data ${DEST_DIR} && \
	chmod 733 ${APP_DIR}/cache && \
	chmod 722 ${APP_DIR}/logs && \ 
	sed -i -e "s|dtapi2|dtapi|g"  ${APP_DIR}/config/database.php && \
	sed -i -e "s|PDO_MySQL|PDO|g"  ${APP_DIR}/config/database.php && \
	sed -i -e "s|localhost;dbname=dtapi|mysql;dbname=dtapi|g"  ${APP_DIR}/config/database.php && \
	sed -i -e "s|'base_url'   => '/',|'base_url'   => '/api/',|g"  ${APP_DIR}/bootstrap.php && \
	sed -i -e "s|RewriteBase /|RewriteBase /api/|g"  ${API_DIR}/.htaccess

COPY ./infrastructure/dtapi.conf  /etc/apache2/sites-available/dtapi.conf
COPY ./infrastructure/.htaccess  ${DEST_DIR}/.htaccess

RUN docker-php-ext-install pdo_mysql && \
        a2ensite dtapi && \
	a2dissite 000-default && \
	a2enmod headers && \
	a2enmod rewrite

  RUN curl -sL https://deb.nodesource.com/setup_14.x |  bash
  RUN apt install nodejs -y

  RUN git clone https://github.com/yurkovskiy/IF-105.UI.dtapi.if.ua.io.git
  RUN npm i npm@latest -g && npm i -g @angular/cli && npm i --prefix ./IF-105.UI.dtapi.if.ua.io
  
  RUN sed -i "s|https://dtapi.if.ua/api/|http://34.105.228.93/api/|" ./IF-105.UI.dtapi.if.ua.io/src/environments/environment.ts && \
      sed -i "s|https://dtapi.if.ua/api/|http://34.105.228.93/api/|" ./IF-105.UI.dtapi.if.ua.io/src/environments/environment.prod.ts

  RUN cd ./IF-105.UI.dtapi.if.ua.io/ && ng build --prod
  RUN cp -r ./IF-105.UI.dtapi.if.ua.io/dist/IF105/* ${DEST_DIR}

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

