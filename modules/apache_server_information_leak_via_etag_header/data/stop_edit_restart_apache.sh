

#!/bin/bash



# Stop Apache web server

sudo systemctl stop apache2



# Edit Apache configuration file to remove version number from ETag header

sudo sed -i 's/^\s*#*\s*FileETag.*/FileETag MTime Size/g' ${PATH_TO_APACHE_CONFIG_FILE}



# Restart Apache web server

sudo systemctl start apache2