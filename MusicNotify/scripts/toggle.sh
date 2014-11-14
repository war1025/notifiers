#/bin/bash

cd ~/.local/share/notifiers/music

case $(mpc toggle | (read a; read b; echo "$b") | awk '{print $1}') in
	"[playing]") gdbus call --session --dest "org.wrowclif.Music" --object-path "/org/wrowclif/Music" --method "org.wrowclif.Music.SetPaused" "false";;
	"[paused]") gdbus call --session --dest "org.wrowclif.Music" --object-path "/org/wrowclif/Music" --method "org.wrowclif.Music.SetPaused" "true";;
esac

./cursong.sh
