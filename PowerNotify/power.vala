using Notify;

[DBus (name="org.freedesktop.UPower.Device")]
public interface Device : Object {

   public signal void changed();

}

void main() {
   Notify.init("power-notify");

   Device device;

   var notification = new Notification(" ", null, null);
   notification.set_hint("transient", true);

   device = Bus.get_proxy_sync(BusType.SYSTEM, "org.freedesktop.UPower",
                                               "/org/freedesktop/UPower/devices/line_power_AC");

   device.changed.connect(() => {
      notification.update("Power changed", "Plugged in Changed", "");
      notification.show();
   });

   var loop = new MainLoop();
   loop.run();
}
