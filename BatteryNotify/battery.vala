using Notify;

[DBus (name="org.wrowclif.Battery")]
public class Battery : Object {

	private Notify.Notification notification;
	private StringBuilder time;
	private StringBuilder icon;

	private static string TITLE_TEMPLATE = "Battery Level: %d%%";
	private static string DISCHARGE_TEMPLATE = "%s remaining";
	private static string CHARGE_TEMPLATE = "%s till full";

	public Battery() {
		notification = new Notify.Notification(" ", null, null);
		notification.set_hint("transient", true);
		time = new StringBuilder();
		icon = new StringBuilder();
	}

	public void show_battery(double percentage, int state, int seconds) {
		time.erase();
		icon.erase();
		var charging = (state == 1);

		icon.append("battery");

		if(percentage < 5) {
			icon.append("-caution");
		} else if(percentage < 30) {
			icon.append("-low");
		} else if(percentage < 70) {
			icon.append("-good");
		} else {
			icon.append("-full");
		}

		if(charging) {
			icon.append("-charging");
		}

		icon.append("-symbolic");

		if(seconds == 0) {
			notification.update(TITLE_TEMPLATE.printf((int) Math.rint(percentage)), "", icon.str);
		} else if(charging) {
			convert_time(seconds);
			notification.update(TITLE_TEMPLATE.printf((int) Math.rint(percentage)), CHARGE_TEMPLATE.printf(time.str), icon.str);
		} else {
			convert_time(seconds);
			notification.update(TITLE_TEMPLATE.printf((int) Math.rint(percentage)), DISCHARGE_TEMPLATE.printf(time.str), icon.str);
		}
		notification.show();
	}

	void convert_time(int seconds) {
		int rounded_time = ((seconds + 150) / 300) * 300;
		int hours = rounded_time / 3600;
		int minutes = (rounded_time % 3600) / 60;

		switch(hours) {
			case 0:
				break;
			case 1:
				time.append("1 hour");
				break;
			default:
				time.append("%d hours".printf(hours));
				break;
		}

		if((hours != 0) && (minutes != 0)) {
			time.append(" and %d minutes".printf(minutes));
		} else if(hours == 0) {
			time.append("%d minutes".printf(minutes));
		}
	}
}

void main() {
	Notify.init("battery-notify");
	Bus.own_name(BusType.SESSION, "org.wrowclif.Battery", BusNameOwnerFlags.NONE,
				(c) => {c.register_object("/org/wrowclif/Battery", new Battery());},
				() => {},
				() => stderr.printf ("Could not aquire name\n"));

	new MainLoop().run();
}
