#pragma once

#include <QObject>

class FakWin : public QObject
{
    Q_OBJECT

public:
    FakWin(QObject *parent);
    virtual ~FakWin();

public Q_SLOTS:
    bool closeWaylandWindows();
};
