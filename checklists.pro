#copy data files: scp -r -P 2223 /home/wim/checklists nemo@localhost:/home/nemo
#ssh -p 2223 nemo@localhost

# The name of your app
TARGET = checklists

# C++ sources
SOURCES += main.cpp

# C++ headers
HEADERS +=

# QML files and folders
qml.files = *.qml pages cover controls main.qml

# The .desktop file
desktop.files = checklists.desktop

# Please do not modify the following line.
include(sailfishapplication/sailfishapplication.pri)

OTHER_FILES = \
    rpm/checklists.yaml \
    rpm/checklists.spec \
    controls/check.png \
    controls/Listbox.qml \
    controls/DelegateList.qml \
    controls/DelegateChecks.qml \
    controls/MFiledialog.qml
