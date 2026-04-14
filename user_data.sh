#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx

# Create simple index.html
cat > /usr/share/nginx/html/index.html << EOF
<!DOCTYPE html>
<html>
<head><title>Nginx on EC2 with Dynatrace</title></head>
<body>
<h1>Hello from Nginx on Terraform EC2!</h1>
<p>Monitored by Dynatrace.</p>
</body>
</html>
EOF


cd /tmp && \
curl -L -H "Authorization: Api-Token " \
"https://azs89024.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" \
-o Dynatrace-OneAgent-Linux.sh


ls -l /tmp/Dynatrace-OneAgent-Linux.sh
head -5 /tmp/Dynatrace-OneAgent-Linux.sh
file /tmp/Dynatrace-OneAgent-Linux.sh

/bin/sh /tmp/Dynatrace-OneAgent-Linux.sh \
--set-monitoring-mode=fullstack \
--set-app-log-content-access=true
