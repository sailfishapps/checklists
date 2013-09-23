
#ifndef SAILFISHAPPLICATION_H
#define SAILFISHAPPLICATION_H
#include <QDebug>
#include "myqquickview.h"

class QString;
class QGuiApplication;
class MyQQuickView;

namespace Sailfish {

QGuiApplication *createApplication(int &argc, char **argv);
MyQQuickView *createView(const QString &);
void showView(MyQQuickView* view);
}

#endif // SAILFISHAPPLICATION_H

