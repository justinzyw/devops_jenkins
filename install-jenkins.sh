#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

sudo docker service scale devops-jenkins=0

echo ---$(currentTime)---populate the volumes---
#to zip, use: sudo tar zcvf devops_jenkins_volume.tar.gz /var/nfs/volumes/devops_jenkins*
sudo tar zxvf devops_jenkins_volume.tar.gz -C /


echo ---$(currentTime)---create jenkins service---
sudo docker service create -d \
--publish $JENKINS_UI_PORT:8080 \
--publish $JENKINS_SLAVE_PORT:50000 \
--name devops-jenkins \
--mount type=volume,source=devops_jenkins_volume,destination=/var/jenkins_home,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_jenkins_volume \
--mount type=volume,source=devops_jenkins_volume_ssh,destination=/root/.ssh,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_jenkins_volume_ssh \
--mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
--mount type=bind,source=/usr/bin/docker,destination=/usr/bin/docker \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$JENKINS_IMAGE

sudo docker service scale devops-jenkins=1