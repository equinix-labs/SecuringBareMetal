PRIVATE_IP=`hostname -I | cut -d ' ' -f 2`
vault agent -dev
