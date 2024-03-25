#include <QDBusConnection>
#include "FakWin.hpp"
#include "kwinadaptor.h"

FakWin::FakWin(QObject* parent) :
	QObject(parent)
{
	new SessionAdaptor(this);
	QDBusConnection dbus = QDBusConnection::sessionBus();
	dbus.registerObject(QStringLiteral("/Session"), QStringLiteral("org.kde.KWin"), this);
	dbus.registerService("org.kde.KWin");
}

FakWin::~FakWin() = default;

bool FakWin::closeWaylandWindows() {
    return true;
}
