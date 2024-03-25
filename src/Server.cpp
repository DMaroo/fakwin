#include <QCoreApplication>
#include "FakWin.hpp"

int main(int argc, char *argv[])
{
  QCoreApplication app(argc, argv);
  FakWin fw(&app);

  return app.exec();
}
