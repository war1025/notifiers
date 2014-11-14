
music : music.vala
	valac --pkg=libnotify ./music.vala

install : music
	mkdir -p ~/.local/share/notifiers/music
	mkdir -p ~/.local/share/notifiers/bin
	mkdir -p ~/.local/share/dbus-1/services
	cp ./music ~/.local/share/notifiers/bin/music_notify
	cp ./scripts/* ~/.local/share/notifiers/music/
	mkdir -p ./temp_services
	rm ./temp_services/*
	cp ./services/* ./temp_services/
	find ./temp_services -type f | xargs sed -i -e "s,~,$(HOME),g"
	cp ./temp_services/* ~/.local/share/dbus-1/services/
	rm -r ./temp_services
