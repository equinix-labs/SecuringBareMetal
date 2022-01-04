VERSION=1.11.1
wget https://releases.hashicorp.com/consul/${VERSION}/consul_${VERSION}_linux_amd64.zip
unzip consul_${VERSION}_linux_amd64.zip
mv consul /usr/local/bin
rm consul_${VERSION}_linux_amd64.zip
