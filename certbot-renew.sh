#!/bin/bash

# Function to check certificate expiration
check_certificate_expiry() {
    domain=$1
    cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"
    if [ ! -f "$cert_file" ]; then
        echo "Certificate file for $domain not found!"
        exit 1
    fi

    expiry_date=$(openssl x509 -enddate -noout -in "$cert_file" | cut -d= -f2)
    expiry_seconds=$(date --date="$expiry_date" +%s)
    current_seconds=$(date +%s)
    seconds_left=$((expiry_seconds - current_seconds))
    days_left=$((seconds_left / 86400))

    echo $days_left
}

# Domain to check
domain="<Domain Name>"

# Check certificate expiration
days_left=$(check_certificate_expiry $domain)

if [ "$days_left" -lt 30 ]; then
    echo "Certificate is less than 30 days from expiry. Proceeding with renewal..."

    # Run a dry run to test the renewal process
    echo "Starting Certbot dry run..."
    /usr/bin/certbot renew --dry-run

    # Check if dry run was successful
    if [ $? -eq 0 ]; then
        echo "Dry run successful, proceeding with certificate renewal..."
        /usr/bin/certbot renew

        # Restart Nginx to apply new certificates
        echo "Restarting Nginx..."
        sudo service nginx restart

        echo "Certificate renewal and Nginx restart complete."
    else
        echo "Dry run failed. Certificates were not renewed."
    fi
else
    echo "Certificate is more than 30 days from expiry. No need to renew."
fi

