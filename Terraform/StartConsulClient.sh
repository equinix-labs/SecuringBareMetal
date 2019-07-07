NUMBER_CONSUL_SERVERS=$1
if [ -z "$NUMBER_CONSUL_SERVERS" ]; then
  NUMBER_CONSUL_SERVERS=1
fi
PRIVATE_IP=`hostname -I | cut -d ' ' -f 2`
consul agent \
  -bootstrap-expect $NUMBER_CONSUL_SERVERS \
  -node=`hostname` \
  -bind $PRIVATE_IP \
  -config-dir=/etc/consul.d
