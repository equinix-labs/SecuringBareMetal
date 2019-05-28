# SecuringBaremetal
Best Practices for Securing Services on Bare Metal




apt-get update -y
apt-get install tcpflow dnsutils zip -y

wget https://releases.hashicorp.com/consul/1.5.1/consul_1.5.1_linux_amd64.zip
unzip consul_1.5.1_linux_amd64.zip
mv consul /usr/local/bin
rm consul_1.5.1_linux_amd64.zip

socat -v tcp-l:8181,fork exec:/bin/cat fortune.json


