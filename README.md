A ready to use docker image for Laravel

The image includes:

- Apache
- PHP
- MySQL Connector
- PHP mcrypt extension
- Composer
- Laravel
- SSL Support

To use with fig:

	´
	web:
	  image: luis/laravel
	  volumes:
	    - "./:/var/www/app"
	    - "/tmp/logs:/var/log/apache2"
	  ports:
	    - "80:80"
	  net: "host"
	´

/var/www/app is where the application lives, if you want to change it, you also need to change Apache's configuration files. Take a look at the files inside the config directory for an example.The files must be mapped to /etc/apache2/sites-enabled

The net: "host" is so you can access MySQL in the host, if you run MySQL in another container, link it.

Logs are at /var/log/apache2

Note: mod_rewrite is automatically enabled, if you don't want it, override the apache files.
