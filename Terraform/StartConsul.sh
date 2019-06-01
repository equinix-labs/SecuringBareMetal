PRIVATE_IP=`hostname -I | cut -d ' ' -f 2`
consul agent -server \
  -node=`hostname` \
  -bind $PRIVATE_IP \
  -config-dir=/etc/consul.d
