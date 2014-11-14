/*
 * Copyright © 2011 Faidon Liambotis <paravoid@debian.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Alternatively, you can redistribute and/or modify this program under the
 * same terms that the “gnome-shell” or “gnome-shell-extensions” software
 * packages are being distributed by The GNOME Project.
 *
 */

const St = imports.gi.St;
const Lang = imports.lang;
const Status = imports.ui.status;
const Panel = imports.ui.panel;
const Main = imports.ui.main;
const Gio = imports.gi.Gio;

const VolumeInterface = '<node>                                 \
                         <interface name="org.wrowclif.Volume"> \
                           <signal name="VolumeChanged">        \
                              <arg type="i" direction="out" />  \
                              <arg type="b" direction="out" />  \
                           </signal>                            \
                        </interface>                            \
                        </node>';

/*{
   name: 'org.wrowclif.Volume',
   signals: [
      {
         name: 'VolumeChanged',
         inSignature: 'ib'
      }
   ]
}*/

const PowerInterface = '<node>                                    \
                        <interface name="org.freedesktop.UPower"> \
                           <signal name="Sleeping" />             \
                        </interface>                              \
                        </node>';

/*{
   name: 'org.freedesktop.UPower',
   signals: [
      {
         name: 'Sleeping'
      }
   ]
}*/

let VolumeProxy = Gio.DBusProxy.makeProxyWrapper(VolumeInterface)
let PowerProxy = Gio.DBusProxy.makeProxyWrapper(PowerInterface)

function init(meta) {
    // empty
}

function enable() {
   // monkey-patch the existing battery icon, called "that" henceforth
   let that = Main.panel.statusArea.aggregateMenu._volume;

   that._power_proxy = new PowerProxy(Gio.DBus.system, 'org.freedesktop.UPower', '/org/freedesktop/UPower');
   that._volume_proxy = new VolumeProxy(Gio.DBus.session, 'org.wrowclif.Volume', '/org/wrowclif/Volume');

   that._onHibernate = function(object, path, args) {
      //this.setIcon('audio-volume-muted');
   }

   that._onVolumeChanged = function(object, path, args) {
      let vol = args[0];
      let muted = args[1];
      this._label.set_text(C_("Volume percent", "%3d%%").format(vol));
      this._lastVolume = vol;
   }

   that.disconnectAll();
   //that.menu = null;

   that._label = new St.Label();
   that._label.set_width(40);
   that._label.set_style("padding-left: 0px;");

   that.indicators.add(that._label, { y_align: St.Align.MIDDLE, y_fill: false });

   that.indicators.get_children()[0].style = "padding-right: 0px;"


   this.id1 = that._power_proxy.connectSignal('Sleeping', Lang.bind(that, that._onHibernate));
   this.id2 = that._volume_proxy.connectSignal('VolumeChanged', Lang.bind(that, that._onVolumeChanged));

   if(that._lastVolume) {
      that._label.set_text(C_("Volume percent", "%3d%%").format(that._lastVolume));
   }
}

function disable() {
   let that = Main.panel.statusArea.aggregateMenu._volume;

   that._power_proxy.disconnectSignal(this.id1);
   that._volume_proxy.disconnectSignal(this.id2);

   that._power_proxy = null;
   that._volume_proxy = null;

   that.indicators.remove_actor(that._label);
}
