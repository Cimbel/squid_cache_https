# Squid cache HTTPS
This is a Docker image which has squid cache proxy on it\
and the proxy allows you to cache data when you go through it.\
More information about squid cache proxy you can find\
on [squid-cache.org](http://www.squid-cache.org/) and [wiki.squid-cache.org](https://wiki.squid-cache.org/)

### Prerequsities
* You need to have docker installed on your OS
* You need internet connection
* Basic knowledge of linux commands (**cd**, **curl**, **ls**, **cat**) and docker

### Try it on your own

1. Build docker image locally from files of the repo (do not change files pathes)
   <br>
   ```bash
   docker build -t my-squid-cache-https:v0.1 .
   ```
2. Run the image you have just built
   <br>
   ```bash
   docker run -d my-squid-cache-https:v0.1 --name squid-cache-proxy
   ```
3. Go inside your container
   <br>
   ```bash
   docker exec -it <container_name> /bin/bash
   ```
4. Run the following command to make first download without local cache

    <br>

   ```bash
   curl -s -x 127.0.0.1:3128 "https://effigis.com/wp-content/themes/effigis_2014/img/RapidEye_RapidEye_5m_RGB_Altotting_Germany_Agriculture_and_Forestry_2009MAY17_8bits_sub_r_2.jpg" -o /tmp/big_picture.jpg
   ```
5. Run the command above one more time and see difference in downloading speed.
6. Check proxy logs which tells you about hitting cache data locally
   
   <br>

   ```bash
   cat /var/log/squid/access.log
   ```

7. You can also check the data itself which has been cached, go to ```/var/spool/squid/00/00``` inside of you container and check the cahed data ```ls -la```

##### **NOTE**!
If you want to use this proxy from antoher container, you
have to move there a root CA of self signed certificate
and use it that proxy can trust you.
Location of the certificate inside of container -> ```/squid_ssl/squid-self-signed.pem```

### Benefits
* Static data cached and available
* Saving bandwith
* Speed up downloading inside of your **network**