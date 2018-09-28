#!/bin/bash

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

#Apply the given parameters on first boot (DGID, DUID, TZ)
if [ ! -f "/etc/initialbootpassed" ]; then

	echo "[$(date +"%H:%M:%S")] [Container Setup]: -------> Initial boot"

	if [ -n "${TZ}" ]; then
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Setting TimeZone"
		cp /usr/share/zoneinfo/$TZ /etc/localtime;
	fi

	if [ -n "${DGID}" ]; then
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Fixing GID"
		OLDGID=$(id -g docker)
		groupmod -g $DGID docker 2>/dev/null
		find / -group $OLDGID -exec chgrp -h docker {} 2>/dev/null \;
	fi

	if [ -n "${DUID}" ]; then
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Fixing UID"
		OLDUID=$(id -u docker)
		usermod -u $DUID docker 2>/dev/null
		find / -user $OLDUID -exec chown -h docker {} 2>/dev/null \;
	fi

	touch /etc/initialbootpassed

	#########################################
	##            DEPLOY JUPYTER           ##
	#########################################

	echo "[$(date +"%H:%M:%S")] [Container Setup]: Installing jupyter"
	/opt/conda/bin/conda install jupyter -y --quiet
	echo "[$(date +"%H:%M:%S")] [Container Setup]: Generating config file"
	/sbin/setuser docker jupyter notebook --generate-config

else
	echo "[$(date +"%H:%M:%S")] [Container Setup]: -------> Standard boot"
fi

