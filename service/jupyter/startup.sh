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

	echo "[$(date +"%H:%M:%S")] [Container Setup]: Installing jupyter & nb_conda"
	/opt/conda/bin/conda install jupyter nb_conda -y --quiet
	# Generate jupyter config file
	/sbin/setuser docker /opt/conda/bin/jupyter notebook --generate-config
	# Fix nb_conda Directory error messagage
	sed -i 's/for env in info\['\''envs'\''\]\]/for env in info\['\''envs'\''\] if env != info\['\''root_prefix'\''\]\]/g' /opt/conda/lib/python3.6/site-packages/nb_conda/envmanager.py
	# Fix nb_conda permission issue"
	echo "[$(date +"%H:%M:%S")] [Container Setup]: Fix permission issue with nb_conda and pkgs (may take some time)"
	#chown -R docker:docker /opt/conda
	chown -R docker:docker /opt/conda/pkgs

else
	echo "[$(date +"%H:%M:%S")] [Container Setup]: -------> Standard boot"
fi

