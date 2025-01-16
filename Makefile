build:
	docker build \
		-t novatel-driver:latest .
run:
	docker run -it \
		--rm \
		--net=host \
		-e QT_X11_NO_MITSHM=1 \
		-e DISPLAY=$(DISPLAY) \
		-e DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket" \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /dev:/dev \
		-v /lib/firmware:/lib/firmware \
		--name novatel-driver \
		novatel-driver