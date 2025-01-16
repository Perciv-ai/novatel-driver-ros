#!/bin/bash
set -e

# Setup ROS Noetic environment
source "/opt/ros/noetic/setup.bash"
# source "/ws/devel/setup.bash"

# Check if ROS_MASTER_IP and ROS_MASTER_HOSTNAME are set
if [ ! -z "$ROS_MASTER_IP" ] && [ ! -z "$ROS_MASTER_HOSTNAME" ]; then
    echo "$ROS_MASTER_IP $ROS_MASTER_HOSTNAME" >> /etc/hosts
fi

# Default to localhost if ROS_MASTER_IP is not set
: ${ROS_MASTER_IP:="localhost"}
: ${ROS_IP:="127.0.0.1"}

# Set ROS_MASTER_URI using the provided IP
ROS_MASTER_URI="http://${ROS_MASTER_IP}:11311"
export ROS_MASTER_URI

# Set ROS_IP
ROS_IP="${ROS_IP}"
export ROS_IP

# Add the ROS_MASTER_URI and ROS_IP to ~/.bashrc so that it's sourced in every shell
echo "export ROS_MASTER_URI=${ROS_MASTER_URI}" >> ~/.bashrc
echo "export ROS_IP=${ROS_IP}" >> ~/.bashrc

# Launch the ROS node
#roslaunch chuhang_driver chuhang.launch

# Run any command passed as an argument in the background
# if [ "$#" -ne 0 ]; then
#   "$@" &
# fi

# # Keep the container alive
# tail -f /dev/null
exec "$@"

