using Notify;

[DBus (name="org.wrowclif.Volume")]
public class Volume : Object {

	private Notification notification;
	private StringBuilder sb;
	private string icon;

	private static unichar FULL = '█';
	private static unichar HALF = '▌';
	private static char SPACE = ' ';
	private static string TITLE_TEMPLATE = "Volume";
	private static string SUMMARY_TEMPLATE = "<span font='mono 10'>%s</span>";

	public Volume() {
		notification = new Notification(" ", null, null);
		notification.set_hint("transient", true);
		sb = new StringBuilder();
		icon = "";
	}

	public void show_volume(int volume, bool muted) {
		sb.erase();
		int volume_64  = (volume * 64) / 65536;
		int volume_100 = (volume * 100) / 65536;
		for(int i = 0; i < 64; i += 2) {
			if((i + 1) == volume_64) {
				sb.append_unichar(HALF);
			} else if(i < volume_64) {
				sb.append_unichar(FULL);
			} else {
				sb.append_c(SPACE);
			}
		}
		if(muted) {
			icon = "audio-volume-muted";
		} else {
			switch(volume_64 / 22) {
				case 0 : icon = "audio-volume-low"; break;
				case 1 : icon = "audio-volume-medium"; break;
				default : icon = "audio-volume-high"; break;
			}
		}
		notification.update(TITLE_TEMPLATE, sb.str, icon);
		notification.show();
		volume_changed(volume_100, muted);
	}

	public signal void volume_changed(int volume, bool muted);
}

void main() {
	Notify.init("volume-notify");
	Bus.own_name(BusType.SESSION, "org.wrowclif.Volume", BusNameOwnerFlags.NONE,
				(c) => {c.register_object("/org/wrowclif/Volume", new Volume());},
				() => {},
				() => stderr.printf ("Could not aquire name\n"));

	new MainLoop().run();
}
