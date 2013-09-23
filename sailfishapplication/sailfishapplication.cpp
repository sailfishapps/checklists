
#include <QGuiApplication>
#include <QDir>

#ifdef HAS_BOOSTER
#include <MDeclarativeCache>
#endif

#include <QQmlComponent>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QQuickItem>

#include "sailfishapplication.h"

QGuiApplication *Sailfish::createApplication(int &argc, char **argv)
{
#ifdef HAS_BOOSTER
    return MDeclarativeCache::qApplication(argc, argv);
#else
    return new QGuiApplication(argc, argv);
#endif
}

MyQQuickView *Sailfish::createView(const QString &file)
{
  MyQQuickView *view = new MyQQuickView(file);
  return view;
}



void Sailfish::showView(MyQQuickView *view)//MyDeclarativeView *view
 {
    view->setResizeMode(QQuickView::SizeRootObjectToView);

    bool isDesktop = qApp->arguments().contains("-desktop");

    if (isDesktop) {
        view->resize(480, 854);
        view->rootObject()->setProperty("_desktop", true);
        view->show();
    } else {
        view->showFullScreen();
    }
}

