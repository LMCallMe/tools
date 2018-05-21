#!/bin/bash
# File              : start-cadvisor.bash
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 21.05.2018
# Last Modified Date: 21.05.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>

htpasswd -c -i -b auth.htpasswd USERNAME PASSWORD \
&& touch newfile \
&& cat <<EOF > Dockerfile
FROM google/cadvisor:latest
ADD auth.htpasswd /auth.htpasswd

EXPOSE 8080
ENTRYPOINT ["/usr/bin/cadvisor", "--http_auth_file", "auth.htpasswd", "--http_auth_realm", "localhost"]
EOF
docker build -t cadvisor . \
&& docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --restart=always \
 cadvisor
