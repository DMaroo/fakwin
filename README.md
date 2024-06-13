# FakWin


> [!IMPORTANT]
> KDE bug tracker link: https://bugs.kde.org/show_bug.cgi?id=488277

Fake KWin DBus service so that KDE 6 shutdown/reboot/logout works when not using KWin. It exposes the `closeWaylandWindows` method through the `org.kde.KWin` service and `/Session` object.

 - KDE 6 commit responsible for the change: https://github.com/KDE/plasma-workspace/commit/23cca93b879d0fcf9f430b03a482dbca1e0a1d79
 - KWin DBus config: https://github.com/KDE/kwin/blob/master/src/org.kde.KWin.Session.xml
 - KWin implementation for the DBus methods: https://github.com/KDE/kwin/blob/master/src/sm.cpp

# Usage

## Building

```
git clone https://github.com/DMaroo/fakwin.git
cd fakwin
mkdir build
cd build
cmake ..
make
```

## Running

The `fakwin` binary gets generated in the `build` directory. Once you run it, it will establish the relevant services and the methods. To check if everything's in order, run the following command.

```
$ qdbus org.kde.KWin /Session
method bool org.kde.KWin.Session.closeWaylandWindows()
signal void org.freedesktop.DBus.Properties.PropertiesChanged(QString interface_name, QVariantMap changed_properties, QStringList invalidated_properties)
method QDBusVariant org.freedesktop.DBus.Properties.Get(QString interface_name, QString property_name)
method QVariantMap org.freedesktop.DBus.Properties.GetAll(QString interface_name)
method void org.freedesktop.DBus.Properties.Set(QString interface_name, QString property_name, QDBusVariant value)
method QString org.freedesktop.DBus.Introspectable.Introspect()
method QString org.freedesktop.DBus.Peer.GetMachineId()
method void org.freedesktop.DBus.Peer.Ping()
```

It is important that the `bool org.kde.KWin.Session.closeWaylandWindows()` shows up in the output.

## Make it persist

You can add a user systemd service for this so that you don't need to run this manually everytime you want to shutdown. Here's an [article](https://www.linode.com/docs/guides/start-service-at-boot/) teaching how to do it.

# Why

https://github.com/heckelson/i3-and-kde-plasma/issues/54 motivated me to build this.

