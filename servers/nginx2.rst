.. _nginx2:

################
nginx: scripting
################

https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04

We set up nginx on Ubuntu in the previous chapter.  Here, we want to set up scripting with php and Python, but I ran into some issues with VirtualBox..

I decided to roll Ubuntu back to ``server2`` and start again.  Let' see how it goes.  We do:

.. sourcecode:: bash

    sudo apt-get update
    sudo apt-get install curl
    sudo apt-get install nginx

The Ubuntu command line:

.. sourcecode:: bash

    te@tom-vb:~$ sudo apt-get install curl
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    curl is already the newest version.
    0 upgraded, 0 newly installed, 0 to remove and 196 not upgraded.
    te@tom-vb:~$ sudo apt-get install nginx
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    nginx is already the newest version.
    0 upgraded, 0 newly installed, 0 to remove and 196 not upgraded.
    te@tom-vb:~$

So it seems clear that the snapshots are not working properly, since neither ``curl`` nor ``nginx`` should be present.  

How about ``server1``?

I saw something in the VirtualBox window about "merging differences"!  Maybe that's it.  Perhaps I am misunderstanding what a snapshot is.  But this conflicts with the VirtualBox docs:

https://www.virtualbox.org/manual/ch01.html#snapshots

Try

.. sourcecode:: bash

    te@tom-vb:~$ dpkg --get-selections | grep apache
    apache2						install
    apache2-bin					install
    apache2-data					install
    libapache2-mod-php5				install
    te@tom-vb:~$

According to 

http://superuser.com/questions/387948/how-can-i-determine-if-apache-is-installed-on-a-system

this indicates that the package ``apache2`` is installed on the system.

Not what I thought.  The same link says to do:

.. sourcecode:: bash

    te@tom-vb:~$ sudo lsof -nPi | grep ":80 (LISTEN)"
    [sudo] password for te: 
    apache2   1356     root    4u  IPv6  11541      0t0  TCP *:80 (LISTEN)
    apache2   1365 www-data    4u  IPv6  11541      0t0  TCP *:80 (LISTEN)
    apache2   1366 www-data    4u  IPv6  11541      0t0  TCP *:80 (LISTEN)
    apache2   1369 www-data    4u  IPv6  11541      0t0  TCP *:80 (LISTEN)
    apache2   1370 www-data    4u  IPv6  11541      0t0  TCP *:80 (LISTEN)
    apache2   1371 www-data    4u  IPv6  11541      0t0  TCP *:80 (LISTEN)
    te@tom-vb:~$

So VirtualBox does *not* simply roll back to the state at the time you take a snapshot.  How annoying.  There seems to be no choice but to start over.  Go back to the first chapter in this section and meet me back here when you are done.  

..

10 minutes passes --- not bad for an OS install, if you think about it.  :)

I save a snapshot and name it ``clean`` without any hope that it will work properly.

I opt not to set up Dropbox again right away.  It was a pain.  

Let's *go*!

.. sourcecode:: bash

    sudo apt-get unpdate
    sudo apt-get install nginx
    te@te-vb:~$ curl -s localhost | head -n 5
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    te@te-vb:~$

.. sourcecode:: bash

    te@te-vb:~$ ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
    10.0.2.15
    fe80::a00:27ff:fe53:c06c
    te@te-vb:~$
    
.. sourcecode:: bash

    te@te-vb:~$ curl -s http://10.0.2.15 | head -n 5
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    te@te-vb:~$

Now, let's work through the tutorial:

I want to try php before we do Python, but we need to install it.

.. sourcecode:: bash

    sudo apt-get install php5-fpm

*************
Install MySQL
*************

I don't plan to use this, but the tutorial says to do it, so we will:

    sudo apt-get install mysql-server
    
I choose ``pw`` as my password.  :)

    sudo mysql_install_db
    sudo mysql_secure_installation


*************
Configure PHP
*************

.. sourcecode:: bash

    sudo apt-get install php5-fpm php5-mysql

.. sourcecode:: bash

    te@tom-vb:~$ sudo nano /etc/php5/fpm/php.ini
    
It's a big file;  we want to find ``cgi.fix_pathinfo=0``.  In ``nano`` I do ``^W ;cgi.fix`` and the line comes up

.. sourcecode:: bash

    ;cgi.fix_pathinfo=1

A value other than ``0`` allows php to guess what script might be good to run when there is no exact match.  I uncomment it (``;`` seems to be the comment symbol), and set the value equal to ``0``.

.. sourcecode:: bash

    te@tom-vb:~$ sudo service php5-fpm restart
    php5-fpm stop/waiting
    php5-fpm start/running, process 3558
    te@tom-vb:~$

***************
Configure nginx
***************

We need to edit the server block for the default server. 

.. sourcecode:: bash

    sudo nano /etc/nginx/sites-available/default
    
We need to change line 6 within the server block (starting with ``server {``) to

    index index.php index.html index.htm;
    
adding ``index.php`` to the line starting with ``index``, and we need to a new ``location`` to the end of the block.  

.. sourcecode:: bash

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }


Here is the uncommented part of it:

``/etc/nginx/sites-available/default``:

.. sourcecode:: bash

    server {
    	listen 80 default_server;
    	listen [::]:80 default_server ipv6only=on;

    	root /usr/share/nginx/html;
    	index index.php index.html index.htm;

    	# Make site accessible from http://localhost/
    	server_name localhost;

    	location / {
    		# First attempt to serve request as file, then
    		# as directory, then fall back to displaying a 404.
    		try_files $uri $uri/ =404;
    		# Uncomment to enable naxsi on this location
    		# include /etc/nginx/naxsi.rules
    	}

            error_page 404 /404.html;
            error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/html;
        }

        location ~ \.php$ {
            try_files $uri $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php5-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    
        
We need restart

.. sourcecode:: bash

    te@tom-vb:~$ sudo service nginx restart

We need the php script from before.  Put it into ``/usr/share/nginx/html/info.php``:

.. sourcecode:: bash

    te@te-vb:~/Desktop$ cat /usr/share/nginx/html/info.php
    <?php
    phpinfo();
    ?>
    te@te-vb:~/Desktop$

.. sourcecode:: bash

    te@te-vb:~/Desktop$ curl -s localhost/info.php | head -n 5
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml"><head>
    <style type="text/css">
    body {background-color: #ffffff; color: #000000;}
    body, td, th, h1, h2 {font-family: sans-serif;}
    te@te-vb:~/Desktop$

It looks better in Firefox:

    .. image:: /figs/nginx_php.png
      :scale: 50 %

******
Python
******

Running Python scripts on nginx is a bit complicated, so I have decided to hold off on this section for a while.

There is a school of thought that serving dynamic content (the result of the scripts) is better suited to Apache, and that what nginx excels at is speed and the ability to handle tens of thousands of simultaneous requests.










