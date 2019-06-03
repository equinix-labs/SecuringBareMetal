wget https://releases.hashicorp.com/vault/1.1.2/vault_1.1.2_linux_amd64.zip
unzip vault_1.1.2_linux_amd64.zip
mv vault /usr/local/bin
rm vault_1.1.2_linux_amd64.zip
vault -autocomplete-install
