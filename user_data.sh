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

# Install Dynatrace OneAgent
TOKEN="${dynatrace_token}"
TENANT="${dynatrace_tenant}"

curl -H "Authorization: Api-Token $TOKEN" "$TENANT/api/v1/deployment/installer/agent/unix/hotspot/current/cloud/aws/download" > oneagent_installer.sh
chmod +x oneagent_installer.sh
./oneagent_installer.sh

# Restart nginx and clean up
systemctl restart nginx
rm oneagent_installer.sh

