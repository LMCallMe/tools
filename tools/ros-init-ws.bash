#!/bin/bash
# File              : ros-init-ws.bash
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 05.01.2018
# Last Modified Date: 05.01.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>
# ROS
 function init-ros(){
     source /opt/ros/kinetic/setup.bash
 }
 
 function init-ws(){
     source /opt/ros/kinetic/setup.bash
     echo 'success to initialize ros'
     _setup=devel/setup.bash
     max_level=$(echo $(pwd) | grep -o '/' | wc -l)
     for (( i=0; i<max_level; i++));
     do
         if [ -f $_setup ]; then
             source $_setup
             echo 'success to initialize ros catkin workspeace'
             return 0
         fi
         _setup=../$_setup
     done;
     echo 'failed to initialize ros catkin workspeace, you have to run init-ws   under the catkin workspeace'
 }

