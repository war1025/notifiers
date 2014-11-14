
battery : battery.vala
	valac -X -lm --pkg=libnotify ./battery.vala

install : battery
	mkdir -p ~/.local/share/notifiers/battery
	mkdir -p ~/.local/share/notifiers/bin
	mkdir -p ~/.local/share/dbus-1/services
	cp ./battery ~/.local/share/notifiers/bin/battery_notify
	cp ./scripts/* ~/.local/share/notifiers/battery/
	mkdir -p ./temp_services
	rm -f ./temp_services/*
	cp ./services/* ./temp_services/
	find ./temp_services -type f | xargs sed -i -e "s,~,$(HOME),g"
	cp ./temp_services/* ~/.local/share/dbus-1/services/
	rm -r ./temp_services
