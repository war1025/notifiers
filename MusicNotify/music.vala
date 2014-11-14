using Notify;

[DBus (name="org.wrowclif.Music")]
public class Music : Object {

	private Notify.Notification notification;
	private bool paused;

	private static string icon = "gtk-jump-to-ltr";

	public Music() {
		this.notification = new Notify.Notification(" ", null, null);
		this.notification.set_hint("transient", true);
		this.paused = false;
	}

	public void show_song(string artist, string title) {
		if(artist == null || title == null) {
			notification.update("MPD not running", null, icon);
		} else if(paused) {
			notification.update("Music Paused", null, icon);
		} else {
			notification.update(artist, title, icon);
		}
		notification.show();
	}

	public void set_paused(bool paused) {
		this.paused = paused;
	}

}

void main() {
	Notify.init("music-notify");
	Bus.own_name(BusType.SESSION, "org.wrowclif.Music", BusNameOwnerFlags.NONE,
				(c) => {c.register_object("/org/wrowclif/Music", new Music());},
				() => {},
				() => stderr.printf ("Could not aquire name\n"));

	new MainLoop().run();
}
