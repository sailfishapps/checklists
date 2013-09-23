#ifndef MYQQUICKVIEW_H
#define MYQQUICKVIEW_H

#include <QGuiApplication>
#include <QDir>
#include <QQuickView>
#include <QQmlContext>

#include <QProcess>
#include "checklistitem.h"
#include <QStandardPaths>

class MyQQuickView : public QQuickView
{
    Q_OBJECT

public:
    explicit MyQQuickView(const QString &file, QWindow *parent = 0);
    ~MyQQuickView();

QList<QObject*> fileNames;//top lvel: aircrafts
QList<QObject*> checkListHeadings;//headings for qml listmodel
QList<QObject*> checkItems;//per checklist

QString currentChecklist;
//three QMaps are in sync with keys
QList< QPair <QString, QString> > checkLists;//name of checklist and text of checks (\n separated); in C++
QList<bool> checkHeadingVals;
QList<bool> checkVals;

private:
QString deploymentPath();
QString deploymentRoot();
void loadHeadings();
void loadItems(bool clear);
int currentHeadingIndex;
int nrOfCheckedHeading, nrOfCheckedItems, totalNrOfheadings;
QString textEditText, currentChecklistsFile;

public slots:
void handlemyQmlSignal2int(int nr, int nr2);
bool handlemyQmlFileSelected(QString name);
void handlemButtonSignal(int nr);
void handlemyQmlListBoxSignal(int listnr, QString name, int total, bool checked, int currentIndex);
bool loadCheckListsAllOverview();
bool loadAndShowChecklists();
void fullRestart();
void restart();
bool fileExists(QString name);
bool compareText(QString newText);
int save(QString fileName, QString text);
void shutDown();

};


#endif // MYQQUICKVIEW_H
