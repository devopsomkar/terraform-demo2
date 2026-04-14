
#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting EC2 bootstrap..."

dnf update -y
dnf install -y nginx curl

systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Nginx on EC2 with Dynatrace</title></head>
<body>
  <h1>Hello from Nginx on Terraform EC2!</h1>
  <p>Monitored by Dynatrace OneAgent.</p>
</body>
</html>
EOF

TOKEN="${dynatrace_token}"
TENANT="${dynatrace_tenant}"

if [[ -z "$${TOKEN}" || -z "$${TENANT}" ]]; then
  echo "Dynatrace tenant or token is empty. Exiting."
  exit 1
fi

cd /tmp

curl -fsSL \
  -H "Authorization: Api-Token $${TOKEN}" \
  "$${TENANT}/api/v1/deployment/installer/agent/unix/hotspot/current/cloud/aws/download" \
  -o oneagent_installer.sh

chmod +x oneagent_installer.sh
/bin/bash ./oneagent_installer.sh

systemctl restart nginx
rm -f /tmp/oneagent_installer.sh

echo "Bootstrap completed successfully."
