# Step 1: Use the official ROS Noetic image as the base
ARG ROS_DISTRO=noetic

FROM ros:${ROS_DISTRO}
ENV DEBIAN_FRONTEND=noninteractive

# Step 2: Install system dependencies required for the build
RUN apt-get update && apt-get install -y --no-install-recommends\
    git \
    build-essential \
    python3-catkin-tools \
    python3-pip \
    python3-rosdep \
    python3-rospkg \
    sudo \
    lsb-release \
    curl \
    cmake \
    git \
    wget \
    vim \
    nano
# Step 3: Add the ROS Noetic package repository
RUN curl -sSL "http://packages.ros.org/ros.key" | apt-key add - \
    && echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -c | awk '{print $2}'` main" > /etc/apt/sources.list.d/ros2.list

ARG ROS=ros-${ROS_DISTRO}
# Step 4: Install ROS dependencies (ensure the list is updated)
RUN apt-get update && apt-get install -y \
    ${ROS}-rosdoc-lite \
    ${ROS}-tf2-geometry-msgs \
    ${ROS}-gps-common \
    ${ROS}-nav-msgs \
    ${ROS}-nmea-msgs 
# Step 5: Set up the environment variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV ROS_DISTRO=${ROS_DISTRO}

# Step 6: Install rosdep (if not installed) and update rosdep
RUN rosdep init || true && rosdep update

RUN apt-get update && apt-get install -y \
    ${ROS}-novatel-oem7-driver
# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Step 7: Copy the 'src' directory from your local machine into the container
RUN mkdir -p /ws/src
WORKDIR /ws
COPY ./src /ws/src
# RUN rosdep install --from-paths src --ignore-src -r -y
# RUN . /opt/ros/${ROS_DISTRO}/setup.bash && . /ws/devel/setup.bash


RUN /bin/bash -c '. /opt/ros/noetic/setup.bash'

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
# RUN echo "source /ws/devel/setup.bash" >> ~/.bashrc

# Step 12: Set up the entry point to run the container interactively with ROS
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Define the entry point for the container
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]