VERSION=1.9.2
wget https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_linux_amd64.zip
unzip vault_${VERSION}_linux_amd64.zip
mv vault /usr/local/bin
rm vault_${VERSION}_linux_amd64.zip
vault -autocomplete-install
