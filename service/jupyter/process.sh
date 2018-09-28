#!/bin/sh

#########################################
##          RUN THE SERVICES           ##
#########################################
#Launch jupyter as "docker" user
exec /sbin/setuser docker /opt/conda/bin/jupyter notebook --notebook-dir=/mnt/data/notebooks --ip='*' --port=8888 --no-browser

