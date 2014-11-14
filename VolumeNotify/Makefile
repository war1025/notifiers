
volume : volume.vala
	valac --pkg=libnotify ./volume.vala

install : volume
	mkdir -p ~/.local/share/notifiers/volume
	mkdir -p ~/.local/share/notifiers/bin
	mkdir -p ~/.local/share/dbus-1/services
	mkdir -p ~/.local/share/gnome-shell/extensions
	cp ./volume ~/.local/share/notifiers/bin/volume_notify
	cp ./scripts/* ~/.local/share/notifiers/volume/
	cp -r ./shell_extension/* ~/.local/share/gnome-shell/extensions/
	mkdir -p ./temp_services
	rm -f ./temp_services/*
	cp ./services/* ./temp_services/
	find ./temp_services -type f | xargs sed -i -e "s,~,$(HOME),g"
	cp ./temp_services/* ~/.local/share/dbus-1/services/
	rm -r ./temp_services
