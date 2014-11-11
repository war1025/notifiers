#/bin/sh

mpc current -f "%artist%\n%title%" | (read a; read t; gdbus call --session --dest "org.wrowclif.Music" --object-path "/org/wrowclif/Music" --method "org.wrowclif.Music.ShowSong" "$a" "$t")
