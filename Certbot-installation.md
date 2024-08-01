Installing Certbot along with its Nginx plugin auto Renewal setup

Step 01: Update Package Lists Using Below command

Below  command refreshes the package lists from the repositories, ensuring we have the latest information on the available packages.

**$ sudo apt-get update**

Step 02: Install Certbot and the Nginx Plugin

Below command installs Certbot, a tool for obtaining and renewing SSL certificates from Let's Encrypt, along with the Nginx plugin, which makes it easier to configure Nginx to use the certificates.

**$ sudo apt install certbot python3-certbot-nginx**

Step 03: Run Certbot command to obtain and install the SSL certificate for specific domain

**$ sudo certbot --nginx -d <Domain Name> -d <Sub Domain Name> --no-redirect**

Example: sudo certbot --nginx -d staging.xyd.ro -d staging-api.xyd.ro --no-redirect

::**Execute the above commands only one time**::

Step 04: Create a log file for Certbot renewal logs

Below command creates an empty file named certbot-renewal.log in the /var/log directory, which will be used to store logs related to Certbot's certificate renewal process.

**$ sudo touch /var/log/certbot-renewal.log**

Step 05: Set permissions for the log file

Below command changes the file permissions of certbot-renewal.log to 664. This means the owner and the group can read and write to the file, while others can only read it.

**$ sudo chmod 664 /var/log/certbot-renewal.log**

Step 06: Create a shell script for Certbot renewal

Below command creates an empty file named certbot-renew.sh in the /usr/local/bin directory. This file will contain the script to renew the SSL certificates using Certbot.

**$ sudo touch /usr/local/bin/certbot-renew.sh**
    
Step 07: Make the shell script executable
  
Below command changes the file permissions of certbot-renew.sh to make it executable. The +x flag adds execute permissions for the owner, group, and others.

**$ sudo chmod +x /usr/local/bin/certbot-renew.sh**

Step 08: Finally save exit the file. Based on the requriment. we can set the crontab

**10 1 1 * * /usr/local/bin/certbot-renew.sh >> /var/log/certbot-renew.log 2>&1**
