
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Apache Server Information Leak via ETag Header
---

This incident type refers to a vulnerability in the Apache web server where sensitive information is leaked through the ETag header. The ETag header is used to help browsers cache web pages and can contain metadata about the file being served. However, if the ETag value is not properly configured, it can inadvertently expose information about the server, such as file paths or version numbers. Attackers can use this information to gain insights into a server's configuration and use it to launch further attacks.

### Parameters
```shell
export APACHE_CONFIG_FILE="PLACEHOLDER"

export SERVER_URL="PLACEHOLDER"

export PATH_TO_APACHE_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check if Apache server is running
```shell
systemctl status apache2
```

### Check Apache server version
```shell
apache2 -v
```

### List Apache modules and check if mod_headers is enabled
```shell
apache2ctl -M | grep headers
```

### Check Apache server configuration for ETag settings
```shell
grep -i ETag ${APACHE_CONFIG_FILE}
```

### Check if ETags are being sent in server responses
```shell
curl -I -s ${SERVER_URL} | grep -i ETag
```

### Check if ETags are being sent in HTTPS responses
```shell
openssl s_client -connect ${SERVER_URL}:443 | openssl x509 -noout -text | grep ETag
```

### Check if ETags are being sent in HTTP/2 responses
```shell
nghttp -H ${SERVER_URL} | grep -i ETag
```

## Repair

### Update the Apache web server to the latest version and apply any patches that address the ETag header vulnerability.
```shell


#!/bin/bash



# Update package repository

sudo apt-get update



# Update Apache web server

sudo apt-get install apache2



# Check Apache version

sudo apache2 -v


```

### Configure the ETag header to only include a secure hash value that does not reveal any sensitive information about the server or its configuration.
```shell


#!/bin/bash



# Stop Apache web server

sudo systemctl stop apache2



# Edit Apache configuration file to remove version number from ETag header

sudo sed -i 's/^\s*#*\s*FileETag.*/FileETag MTime Size/g' ${PATH_TO_APACHE_CONFIG_FILE}



# Restart Apache web server

sudo systemctl start apache2


```