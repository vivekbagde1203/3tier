MYPIP=$(curl -sL http://169.254.169.254/latest/meta-data/public-ipv4)
INSTANCEID=$(curl -sL http://169.254.169.254/latest/meta-data/instance-id)
AMIID=$(curl -sL http://169.254.169.254/latest/meta-data/ami-id)
SECURITYGROUPS=$(curl -sL http://169.254.169.254/latest/meta-data/security-groups)
LOCALIP=$(curl -sL http://169.254.169.254/latest/meta-data/local-ipv4)
echo "The public IP is: "${MYPIP}"."
echo "The Instance id is: "${INSTANCEID}"."
echo "The ami-id is: "${AMIID}"."
echo "The security-groups are: "${SECURITYGROUPS}"."
echo "The local-ip is: "${LOCALIP}"."