
#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Nginx on EC2 with Dynatrace</title></head>
<body>
<h1>Hello from Nginx on Terraform EC2!</h1>
<p>Monitored by Dynatrace.</p>
</body>
</html>
EOF

TOKEN="${dynatrace_token}"
TENANT="${dynatrace_tenant}"

echo "Dynatrace tenant: $TENANT" | tee -a /var/log/user-data.log

curl -sS -D /tmp/dt_headers.txt \
  -H "Authorization: Api-Token $TOKEN" \
  -o /tmp/oneagent_installer.sh \
  "$TENANT/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default"

echo "Dynatrace response headers:" | tee -a /var/log/user-data.log
cat /tmp/dt_headers.txt | tee -a /var/log/user-data.log

head -c 300 /tmp/oneagent_installer.sh | tee -a /var/log/user-data.log

chmod +x /tmp/oneagent_installer.sh
/tmp/oneagent_installer.sh APP_LOG_CONTENT_ACCESS=1
systemctl restart nginx
