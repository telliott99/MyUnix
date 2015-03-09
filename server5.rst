.. _server5:

#############
Apache server
#############

In this chapter, we will set up an Apache server (2.4) and get it configured for running scripts through the ``cgi-bin`` (common gateway interface) mechanism.  I made note of all my old blog posts about this in the first chapter on :ref:`Linux<server1>`, but working through them, I realize that a lot of that stuff wasn't necessary, so we'll try to do a minimal installation.

Of the installs mentioned in those posts, one set that I haven't yet done is

sudo apt-get install dkms build-essential linux-headers-generic

I am going to hold off on doing these.

What I did next:

* ``sudo apt-get install apache2``
* ``sudo apt-get install curl``

In some runs I also did

* ``sudo apt-get install php5 libapache2-mod-php5``
* ``sudo apt-get install libapache2-mod-python``

but I found that these are not necessary.  ``libapache2-mod-python`` sounds like a module to use python with apache, but it really is a module to embed python *within* an apache server.  So we should skip these for now.

Useful commands to remember with the apache server are ``start``, ``stop`` and ``restart``.  Any change to the server needs a restart for it to take effect.  They can be invoked in any of three ways:

* ``sudo /etc/init.d/apache2 restart``
* ``sudo apache2ctl restart``
* ``sudo service apache2 restart``

As far as I know right now they are equivalent.  We will use ``apachectl``

Now do:

.. sourcecode:: bash

    sudo apache2ctl start

A quick test with ``curl localhost`` shows that Apache2 is up and running.

The web page that is served comes from ``/var/www/html/index.html``.

At this point, use VirtualBox to make a new snapshot with the clean install:  ``apache``.

******************
Configuring Apache
******************

Next, I'd like to configure Apache to serve scripts.

Here are some docs

http://httpd.apache.org/docs/current/howto/cgi.html

Every time I've gone through this before, I've done a change of setting (with Ubuntu powered down).

.. sourcecode:: bash

    VBoxManage modifyvm Ubuntu --natpf1 "server,tcp,,8080,,8080"

This tells VirtualBox to do *Network Address Translation* or NAT.  But it is not necessary to get the basic server to work.  So don't do that yet.

Since I installed Dropbox, I am going to do the editing by copying the files to ``~/Dropbox/Ubuntu``, modifying them with TextMate on OS X, and then copying back to the original locations.  And since I can start over at any time using the snapshot, I will not bother to make copies, but normally one should save a copy of the original for any config file that you edit.

So the first thing the docs say is I need something like:

``LoadModule cgi_module modules/mod_cgi.so``

and the problem is that this is supposed to go in ``httpd.conf``, which does not seem to exist in ``/etc/apache2``.

.. sourcecode:: bash

    te@tom-vb:/etc/apache2$ find /etc | grep "httpd"
    find: `/etc/cups/ssl': Permission denied
    /etc/lighttpd
    /etc/lighttpd/conf-enabled
    /etc/lighttpd/conf-enabled/90-javascript-alias.conf
    /etc/lighttpd/conf-available
    /etc/lighttpd/conf-available/90-javascript-alias.conf
    find: `/etc/ssl/private': Permission denied
    find: `/etc/polkit-1/localauthority': Permission denied
    te@tom-vb:/etc/apache2$

A help page from Ubuntu

https://help.ubuntu.com/lts/serverguide/httpd.html

explains that now ``httpd.conf`` does not exist!  This Ubuntu documentation is more up-to-date than that from Apache, but it is hardly more user-friendly.  We will have to see.

.. note::

   Useful info:

    mods-enabled:  holds symlinks to the files in ``/etc/apache2/mods-available``.  When a module configuration file is symlinked it will be enabled the next time apache2 is restarted.

What this means is that we should edit the files in ``available`` rather than ``enabled`` since the latter are just symbolic links.

We need to tell apache to load ``mod_cgi.so``?

Let's look at the environment variables in ``envvars``.  

.. sourcecode:: bash

    # envvars - default environment variables for apache2ctl

    # this won't be correct after changing uid
    unset HOME

    # for supporting multiple apache2 instances
    if [ "${APACHE_CONFDIR##/etc/apache2-}" != "${APACHE_CONFDIR}" ] ; then
    	SUFFIX="-${APACHE_CONFDIR##/etc/apache2-}"
    else
    	SUFFIX=
    fi

    # Since there is no sane way to get the parsed apache2 config in scripts, some
    # settings are defined via environment variables and then used in apache2ctl,
    # /etc/init.d/apache2, /etc/logrotate.d/apache2, etc.
    export APACHE_RUN_USER=www-data
    export APACHE_RUN_GROUP=www-data
    # temporary state file location. This might be changed to /run in Wheezy+1
    export APACHE_PID_FILE=/var/run/apache2/apache2$SUFFIX.pid
    export APACHE_RUN_DIR=/var/run/apache2$SUFFIX
    export APACHE_LOCK_DIR=/var/lock/apache2$SUFFIX
    # Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
    export APACHE_LOG_DIR=/var/log/apache2$SUFFIX

    ## The locale used by some modules like mod_dav
    export LANG=C
    ## Uncomment the following line to use the system default locale instead:
    #. /etc/default/locale

    export LANG

    ## The command to get the status for 'apache2ctl status'.
    ## Some packages providing 'www-browser' need '--dump' instead of '-dump'.
    #export APACHE_LYNX='www-browser -dump'

    ## If you need a higher file descriptor limit, uncomment and adjust the
    ## following line (default is 8192):
    #APACHE_ULIMIT_MAX_FILES='ulimit -n 65536'

    ## If you would like to pass arguments to the web server, add them below
    ## to the APACHE_ARGUMENTS environment.
    #export APACHE_ARGUMENTS=''

    ## Enable the debug mode for maintainer scripts.
    ## This will produce a verbose output on package installations of web server modules and web application
    ## installations which interact with Apache
    #export APACHE2_MAINTSCRIPT_DEBUG=1

Not much help there.  If we look within ``mods-available`` we see three files with ``cgi`` in the filename:

.. sourcecode:: bash

    te@tom-vb:/etc/apache2/mods-available$ cat cgi.load
    LoadModule cgi_module /usr/lib/apache2/modules/mod_cgi.so
    te@tom-vb:/etc/apache2/mods-available$

.. sourcecode:: bash

    te@tom-vb:/etc/apache2/mods-available$ cat cgid.conf
    # Socket for cgid communication
    ScriptSock ${APACHE_RUN_DIR}/cgisock

    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
    te@tom-vb:/etc/apache2/mods-available$

.. sourcecode:: bash

    te@tom-vb:/etc/apache2/mods-available$ cat cgid.load
    LoadModule cgid_module /usr/lib/apache2/modules/mod_cgid.so
    te@tom-vb:/etc/apache2/mods-available$

but none in ``mods-enabled``:

.. sourcecode:: bash

    te@tom-vb:/etc/apache2/mods-available$ ls ../mods-enabled/
    access_compat.load  authz_user.load  filter.load       php5.load
    alias.conf          autoindex.conf   mime.conf         python.load
    alias.load          autoindex.load   mime.load         setenvif.conf
    auth_basic.load     deflate.conf     mpm_prefork.conf  setenvif.load
    authn_core.load     deflate.load     mpm_prefork.load  status.conf
    authn_file.load     dir.conf         negotiation.conf  status.load
    authz_core.load     dir.load         negotiation.load
    authz_host.load     env.load         php5.conf
    te@tom-vb:/etc/apache2/mods-available$
    

On ``libapache2-mod-python`` that we talked about earlier.

From something on the web

    Mod_python is an Apache module that embeds the Python interpreter within the server. With mod_python you can write web-based applications in Python that will run many times faster than traditional CGI and will have access to advanced features such as ability to retain database connections and other data between hits and access to Apache internals. A more detailed description of what mod_python can do is available in this O'Reilly article.

So this makes it pretty clear that we don't need ``libapache2-mod-python``, and we have both ``php5.load`` and ``python.load`` above in ``mods-enabled``.

From the printout above, the directives to load the cgi module look good.  But they are not sym-linked into ``mods-enabled``.  Should we do that manually?  There is a recommended tool for it, so let's use it.  We need to do ``sudo a2enmod cgi``

http://askubuntu.com/questions/403067/cgi-bin-not-working

From the man page:

    a2enmod  is  a  script  that  enables  the  specified module within the
    apache2 configuration.   It  does  this  by  creating  symlinks  within
    /etc/apache2/mods-enabled.   Likewise,  a2dismod  disables  a module by
    removing those symlinks.  It is not an error to enable a  module  which
    is already enabled, or to disable one which is already disabled.

So I will do this:

.. sourcecode:: bash

    sudo a2enmod cgi
    sudo apachectl restart

And take a look:

.. sourcecode:: bash

    te@tom-vb:/etc/apache2$ ls mods-enabled | grep "cgi"
    cgi.load
    te@tom-vb:/etc/apache2$

So at this point we have only done one *required* step:

.. note::

   Requirement #1

.. sourcecode:: bash

    sudo a2enmod cgi
    sudo apachectl restart

Now, what else?  Other things I reported in the blog have to do with listening on port 8080, and setting the script directory to be something other than the default.  ``ScriptAlias`` is the directive to set this directory.  

.. sourcecode:: bash

    te@tom-vb:/etc/apache2$ cat conf-available/serve-cgi-bin.conf 
    <IfModule mod_alias.c>
    	<IfModule mod_cgi.c>
    		Define ENABLE_USR_LIB_CGI_BIN
    	</IfModule>

    	<IfModule mod_cgid.c>
    		Define ENABLE_USR_LIB_CGI_BIN
    	</IfModule>

    	<IfDefine ENABLE_USR_LIB_CGI_BIN>
    		ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
    		<Directory "/usr/lib/cgi-bin">
    			AllowOverride None
    			Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
    			Require all granted
    		</Directory>
    	</IfDefine>
    </IfModule>

    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
    te@tom-vb:/etc/apache2$

In the default setting it seems to be ``/usr/lib/cgi-bin``, and I would like to try going ahead without changing that.

I note a variable ``ENABLE_USR_LIB_CGI_BIN``, which is set ``IfModule mod_alias.c .. IfModule mod_cgi.c``.  Maybe I can run the server in debug mode and see if this is set.

If we did want to edit this ``ScriptAlias``.

* ``sudo cp /etc/apache2/conf-available/serve-cgi-bin.conf ~/Dropbox/Ubuntu``

* ``sudo cp ~/Dropbox/Ubuntu/serve-cgi-bin.conf /etc/apache2/conf-available``

.. note::

   Requirement #2:  python

We need a script:

``script.py``:

.. sourcecode:: python

    #! /usr/bin/python
    
    print "Content-type:  text/html\n\n"
    print "Hello, world!"

On my early attempts, my Python script failed while a php script succeeded, pointing me to something specific about Python  The second line is a critical change from early attempts.  Its absence accounted for the early failures.

``script.py`` is in ``~/Dropbox/Ubuntu``.  Copy it to ``/usr/lib/cgi-bin`` 

* ``sudo cp ~/Dropbox/Ubuntu/script.py /usr/lib/cgi-bin``

and *check the permissions*

.. sourcecode:: bash

    te@tom-vb:~$ sudo cp ~/Dropbox/Ubuntu/script.py /usr/lib/cgi-bin
    te@tom-vb:~$ ls -al /usr/lib/cgi-bin/script.py
    -rw-r--r-- 1 root root 79 Mar  8 21:52 /usr/lib/cgi-bin/script.py
    te@tom-vb:~$ sudo chmod 755 /usr/lib/cgi-bin/script.py
    te@tom-vb:~$ sudo chown `whoami` /usr/lib/cgi-bin/script.py
    te@tom-vb:~$ sudo chgrp adm /usr/lib/cgi-bin/script.py
    te@tom-vb:~$ /usr/lib/cgi-bin/script.py
    Content-type:  text/html


    Hello, world!
    te@tom-vb:~$
    

Now, is it going to work?  Yes!

.. sourcecode:: bash

    te@tom-vb:~$ curl localhost/cgi-bin/script.py

    Hello, world!
    te@tom-vb:~$

I also got php to work.

.. note::

   Requirement #2b:  php

Here is a simple php script:

``info.php``:

.. sourcecode:: php

    <?php
    phpinfo();
    ?>

Put this into ``~/Dropbox/Ubuntu`` and then copy it into ``/usr/lib/cgi-bin``.  Then check its permissions.

.. sourcecode:: bash

    te@tom-vb:~$ sudo cp ~/Dropbox/Ubuntu/info.php /usr/lib/cgi-bin
    te@tom-vb:~$ ls -al /usr/lib/cgi-bin/info.php
    -rw-r--r-- 1 root root 20 Mar  8 21:55 /usr/lib/cgi-bin/info.php
    te@tom-vb:~$ sudo chmod 755 /usr/lib/cgi-bin/info.php
    te@tom-vb:~$ sudo chown `whoami` /usr/lib/cgi-bin/info.php
    te@tom-vb:~$ sudo chgrp adm /usr/lib/cgi-bin/info.php
    te@tom-vb:~$ ls -al /usr/lib/cgi-bin/info.php
    -rwxr-xr-x 1 te adm 20 Mar  8 21:55 /usr/lib/cgi-bin/info.php
    te@tom-vb:~$
    
    te@tom-vb:~$ curl localhost/cgi-bin/info.php
    ..
    
I won't show the output, which is extensive, but it seems to work!  Try it in Firefox:

.. image:: /figs/apache_php_firefox.png
  :scale: 50 %

It definitely works!  

As I said, the first time through I had the problem that it worked with php but not with Python.  So then I thought:

Maybe we can run the server in debug mode, or check the log.  Where are the logs?

The server error log is set by the ErrorLog directive in ``etc/apache2/apache2.conf`` as ``${APACHE_LOG_DIR}/error.log``, but where is that?  In ``envvars`` we have ``/var/log/apache2$SUFFIX``.

.. sourcecode:: bash

    te@tom-vb:/etc/apache2$ cat envvars | grep "LOG"
    export APACHE_LOG_DIR=/var/log/apache2$SUFFIX
    te@tom-vb:/etc/apache2$

So try the Python script again (the broken version):

.. sourcecode:: bash

    te@tom-vb:/var/log/apache2$ curl localhost/cgi-bin/script.py
    <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
    <html><head>
    <title>500 Internal Server Error</title>
    </head><body>
    <h1>Internal Server Error</h1>
    <p>The server encountered an internal error or
    misconfiguration and was unable to complete
    your request.</p>
    <p>Please contact the server administrator at 
     webmaster@localhost to inform them of the time this error occurred,
     and the actions you performed just before this error.</p>
    <p>More information about this error may be available
    in the server error log.</p>
    <hr>
    <address>Apache/2.4.10 (Ubuntu) Server at localhost Port 80</address>
    </body></html>
    te@tom-vb:/var/log/apache2$ tail -n 5 /var/log/apache2/error.log 
    [Sun Mar 08 21:01:52.252854 2015] [:notice] [pid 1184] mod_python: using mutex_directory /tmp 
    [Sun Mar 08 21:01:52.271803 2015] [mpm_prefork:notice] [pid 1184] AH00163: Apache/2.4.10 (Ubuntu) PHP/5.5.12-2ubuntu4.2 mod_python/3.3.1 Python/2.7.8 configured -- resuming normal operations
    [Sun Mar 08 21:01:52.271854 2015] [core:notice] [pid 1184] AH00094: Command line: '/usr/sbin/apache2'
    [Sun Mar 08 21:05:09.628818 2015] [cgi:error] [pid 1189] [client 127.0.0.1:35327] malformed header from script 'script.py': Bad header: Hello, world!
    [Sun Mar 08 21:15:14.202181 2015] [cgi:error] [pid 1190] [client 127.0.0.1:35330] malformed header from script 'script.py': Bad header: Hello, world!
    te@tom-vb:/var/log/apache2$
    
So the first thing is this is not a 404.  And the second thing is that the latest log info is:

.. sourcecode:: bash

    [Sun Mar 08 21:05:09.628818 2015] [cgi:error] [pid 1189] [client 127.0.0.1:35327] malformed header from script 'script.py': Bad header: Hello, world!
    te@tom-vb:/var/log/apache2$

``malformed header``.  Hmmm.  And that's what led me to the solution.

http://stackoverflow.com/questions/14126144/perl-cgi-error-message-br-malformed-header-from-script-bad-header-ltbod

Aside: a quick look at ``cgi-bin`` shows:

.. sourcecode:: bash

    te@tom-vb:~$ ls -al /usr/lib/cgi-bin/
    total 8988
    drwxr-xr-x   2 root root    4096 Mar  8 20:25 .
    drwxr-xr-x 158 root root   20480 Mar  8 19:04 ..
    -rwxr-xr-x   1 te   adm       20 Mar  8 20:25 info.php
    lrwxrwxrwx   1 root root      29 Mar  8 20:20 php -> /etc/alternatives/php-cgi-bin
    -rwxr-xr-x   1 root root 9167936 Feb 13 14:10 php5
    -rwxr-xr-x   1 te   adm       41 Mar  8 20:10 script.py
    te@tom-vb:~$

What are those other things?  Are they necessary to the behavior we see?

.. sourcecode:: bash

    te@tom-vb:/usr/lib/cgi-bin$ ls -al
    total 36
    drwxr-xr-x   3 root root  4096 Mar  8 20:46 .
    drwxr-xr-x 158 root root 20480 Mar  8 19:04 ..
    -rwxr-xr-x   1 te   adm     20 Mar  8 20:25 info.php
    -rwxr-xr-x   1 te   adm     41 Mar  8 20:10 script.py
    drwxr-xr-x   2 root root  4096 Mar  8 20:46 tmp
    te@tom-vb:/usr/lib/cgi-bin$

Nope, it still works.

More:

.. sourcecode:: bash

    te@tom-vb:/usr/lib/cgi-bin$ ls -al /etc/alternatives/php-cgi-bin
    lrwxrwxrwx 1 root root 21 Mar  8 20:20 /etc/alternatives/php-cgi-bin -> /usr/lib/cgi-bin/php5
    te@tom-vb:/usr/lib/cgi-bin$

So ``/usr/lib/cgi-bin/php`` is a link to ``/etc/alternatives/php-cgi-bin`` which is a link to ``/usr/lib/cgi-bin/php5``.  From the size above (9167936), it might be some kind of big binary.  It is not a text file:

.. sourcecode:: bash

    te@tom-vb:~$ hexdump -C -n 64 /usr/lib/cgi-bin/tmp/php5
    00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
    00000010  02 00 3e 00 01 00 00 00  a5 3a 46 00 00 00 00 00  |..>......:F.....|
    00000020  40 00 00 00 00 00 00 00  40 dc 8b 00 00 00 00 00  |@.......@.......|
    00000030  00 00 00 00 40 00 38 00  09 00 40 00 20 00 1f 00  |....@.8...@. ...|
    00000040
    te@tom-vb:~$

``7f 45 4c 46`` is a magic number, an ELF header for a binary file.

.. sourcecode:: bash

    te@tom-vb:/usr/lib/cgi-bin/tmp$ ./php5 -v
    PHP 5.5.12-2ubuntu4.2 (cgi-fcgi) (built: Feb 13 2015 18:57:05)
    Copyright (c) 1997-2014 The PHP Group
    Zend Engine v2.5.0, Copyright (c) 1998-2014 Zend Technologies
       with Zend OPcache v7.0.4-dev, Copyright (c) 1999-2014, by Zend Technologies
    te@tom-vb:/usr/lib/cgi-bin/tmp$

It is a ``php`` binary.

Make a snapshot and call it  ``server5``.  Essential steps we did were just:

.. sourcecode:: bash

    sudo apt-get install apache curl php5
    sudo a2enmod cgi
    sudo apachectl restart

    sudo cp ~/Dropbox/Ubuntu/script.py /usr/lib/cgi-bin
    sudo chmod 755 /usr/lib/cgi-bin/script.py
    sudo chown `whoami` /usr/lib/cgi-bin/script.py
    sudo chgrp adm /usr/lib/cgi-bin/script.py

    sudo cp ~/Dropbox/Ubuntu/info.php /usr/lib/cgi-bin
    sudo chmod 755 /usr/lib/cgi-bin/info.php
    sudo chown `whoami` /usr/lib/cgi-bin/info.php
    sudo chgrp adm /usr/lib/cgi-bin/info.php
    
    curl localhost/cgi-bin/info.php
    curl localhost/cgi-bin/script.py



