QT += quick qml

SOURCES += $$PWD/sailfishapplication.cpp \
    sailfishapplication/myqquickview.cpp \
    sailfishapplication/checklistitem.cpp
HEADERS += $$PWD/sailfishapplication.h \
    sailfishapplication/myqquickview.h \
    sailfishapplication/checklistitem.h
INCLUDEPATH += $$PWD

TARGETPATH = /usr/bin
target.path = $$TARGETPATH

DEPLOYMENT_PATH = /usr/share/$$TARGET
qml.path = $$DEPLOYMENT_PATH
desktop.path = /usr/share/applications

contains(CONFIG, desktop) {
    DEFINES *= DESKTOP
}

INSTALLS += target qml desktop

DEFINES += DEPLOYMENT_PATH=\"\\\"\"$${DEPLOYMENT_PATH}/\"\\\"\"

CONFIG += link_pkgconfig
packagesExist(qdeclarative-boostable) {
    message("Building with qdeclarative-boostable support")
    DEFINES += HAS_BOOSTER
    PKGCONFIG += qdeclarative-boostable
} else {
    warning("qdeclarative-boostable not available; startup times will be slower")
}




