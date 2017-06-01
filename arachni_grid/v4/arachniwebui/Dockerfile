FROM ahannigan/docker-arachni:latest

RUN	apt-get update -y \
	&& apt-get install wkhtmltopdf unzip xvfb iceweasel python-pip xserver-xephyr imagemagick -y \
	&& pip install selenium
	 
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
