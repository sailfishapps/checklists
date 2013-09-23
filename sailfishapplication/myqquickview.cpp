//copy data files: scp -r -P 2223 /home/wim/checklists nemo@localhost:/home/nemo
//ssh -p 2223 nemo@localhost
#include "myqquickview.h"

MyQQuickView::MyQQuickView(const QString &file, QWindow *parent) :
    QQuickView(parent), nrOfCheckedItems(0), nrOfCheckedHeading(0), totalNrOfheadings(0)
{
rootContext()->setContextProperty("myqquickview",  this );
loadCheckListsAllOverview();

 if(file.contains(":")) {
     setSource(QUrl(file));
 } else {
     setSource(QUrl::fromLocalFile(deploymentPath() + file));
 };


 QObject::connect((QObject*)rootObject(), SIGNAL(myQmlListBoxSignal(int, QString, int, bool, int)), this, SLOT(handlemyQmlListBoxSignal(int,QString,int,bool,int)) );
 QObject::connect((QObject*)rootObject(), SIGNAL(mButtonSignal(int)), this, SLOT(handlemButtonSignal(int)) );
}

void MyQQuickView::shutDown()
{
close();
}

bool MyQQuickView::compareText(QString newText)
{
    if (textEditText.compare(newText, Qt::CaseSensitive) != 0)
     {return true;}
    else
     {return false;}
}

bool MyQQuickView::fileExists(QString name)// true = exists
{
QFileInfo fileInfo(QDir::homePath() + "/checklistsdata/" + name);
return fileInfo.exists();
}

void MyQQuickView::fullRestart()
{
 currentHeadingIndex = 0;
 nrOfCheckedHeading = 0;
 nrOfCheckedItems = 0;
 totalNrOfheadings = 0;
 checkListHeadings.clear();
 checkItems.clear();
 currentChecklist.clear();
 checkLists.clear();
 checkHeadingVals.clear();
 checkVals.clear();
 loadCheckListsAllOverview();
}

void MyQQuickView::restart()
{
 currentHeadingIndex = 0;
 nrOfCheckedHeading = 0;
 nrOfCheckedItems = 0;
 totalNrOfheadings = 0;
 checkListHeadings.clear();
 checkItems.clear();
 currentChecklist.clear();
 checkLists.clear();
 checkHeadingVals.clear();
 checkVals.clear();
}

QString MyQQuickView::deploymentPath()
{
    bool isDesktop = qApp->arguments().contains("-desktop");
    QString path;
    if (isDesktop) {
        path = qApp->applicationDirPath() + QDir::separator();
    } else {
        path = deploymentRoot() + QString(DEPLOYMENT_PATH);
    }

    return path;
}

QString MyQQuickView::deploymentRoot()
{
    if(QCoreApplication::applicationFilePath().startsWith("/opt/sdk/")) {
        // Deployed under /opt/sdk/<app-name>/..
        // parse the base path from application binary's path and use it as base
        QString basePath = QCoreApplication::applicationFilePath();
        basePath.chop(basePath.length() -  basePath.indexOf("/", 9)); // first index after /opt/sdk/
        return basePath;
    } else {
        return "";
    }
}

MyQQuickView::~MyQQuickView()
{
}

void MyQQuickView::handlemyQmlSignal2int(int nr, int nr2)
{
//dummy
}

int MyQQuickView::save(QString fileName, QString text)
{
 if (fileName == "")
  {fileName = currentChecklistsFile;}
 QString filepath = QDir::homePath() + QString("/checklistsdata/") + fileName ;
 QFile file(filepath);
  if (! file.open(QIODevice::WriteOnly | QIODevice::Text))
   {
   return 100;
   }
  QTextStream out(&file);
  out << text;
  file.close();
  return 0;
}

void MyQQuickView::handlemButtonSignal(int nr)
{
  if (nr == 1)//edit
   {
   //key has no \n
   //in value the items end with \n
   textEditText.clear();
   textEditText = "*" + checkLists.at(0).first + "\n";
   textEditText = textEditText + checkLists.at(0).second;
   //first handle the keys
   for (int n = 1; n < checkLists.size(); ++n)
     {
     textEditText = textEditText + checkLists.at(n).first + "\n*";
     textEditText = textEditText + checkLists.at(n).second;
     }
   QVariant returnedValue;
   QVariant text = textEditText;
   QMetaObject::invokeMethod((QObject*)rootObject(), "loadTextEdit",
Q_RETURN_ARG(QVariant, returnedValue), Q_ARG(QVariant, text));
   }
}

bool MyQQuickView::handlemyQmlFileSelected(QString name)//load the checklist of this aircraft(type) into the checkLists var
{
 currentChecklistsFile = name;
 //reset thses checklists (in case of being re-visited)
 for(int n = 0; n < fileNames.size(); n++ )
   {
   CheckListItem* test = (CheckListItem*)fileNames[n];
   if (test->checkItem() == currentChecklistsFile)
   {test->setChecked(false);}
   }
 rootContext()->setContextProperty("fileNames",  QVariant::fromValue(fileNames) );

 checkLists.clear();//holding all checlists for one aircraft(type)
 QString filepath = QDir::homePath() + QString("/checklistsdata/") + name;
 QFile file(filepath);
 if (! file.open(QIODevice::ReadOnly | QIODevice::Text))
       {
       return false;
       }
 QString line;
 QPair<QString, QString> rec;
 rec.first = file.readLine().replace("\n","");//first heading
 rec.first.replace("*","");
 while (! file.atEnd() )
   {
   line = file.readLine();
   if (line.startsWith("*", Qt::CaseSensitive))//new one coming
    {
    checkLists.append(rec);
    rec.first = line.replace("\n","");//new heading
    rec.first.replace("*","");
    rec.second = "";
    }
   else
    {
    rec.second = rec.second + line;
    }
   }// /parse the file line by line
 checkLists.append(rec);
 file.close();
 if (checkLists.empty())//add a dummy
   {
   return false;
   }
 if (! loadAndShowChecklists())//now load into QML based on checkLists var
  {return false;}
 QVariant returnedValue;
 QMetaObject::invokeMethod((QObject*)rootObject(), "showCheckLists",
  Q_RETURN_ARG(QVariant, returnedValue));
 if (! returnedValue.toBool())
  {
  return false;
  }
 return true;
}

void MyQQuickView::handlemyQmlListBoxSignal(int listViewNr, QString name, int total, bool checked, int currentIndex)//currentIndex from items, not headings
{
if (listViewNr == 1)
 {
  nrOfCheckedItems = 0;
  currentChecklist = name;
  currentHeadingIndex = currentIndex;
  if (checkHeadingVals[currentHeadingIndex] == true)
    {
    checkHeadingVals[currentHeadingIndex] = false;
     nrOfCheckedHeading--;
    }
  loadHeadings();
  loadItems(true);
 }
else if (listViewNr == 2)
 {
  if (checked) {nrOfCheckedItems++;}
  else {nrOfCheckedItems--;}
  checkVals[currentIndex] = checked;//set the new value
  loadItems(false);
  if (total == nrOfCheckedItems)//ready
   {
   checkHeadingVals[currentHeadingIndex] = checked;
   nrOfCheckedHeading++;
   if (nrOfCheckedHeading == totalNrOfheadings)//complete checklist ready
     {
     QVariant returnedValue;
     QVariant msg = "Checklists are completed.";
     QMetaObject::invokeMethod((QObject*)rootObject(), "ready", Qt::DirectConnection, Q_RETURN_ARG(QVariant, returnedValue), Q_ARG(QVariant, msg));
     //set the main (file)list
     for(int n = 0; n < fileNames.size(); n++ )
     {
      CheckListItem* test = (CheckListItem*)fileNames[n];
      if (test->checkItem() == currentChecklistsFile)
      {test->setChecked(true);}
     }
     rootContext()->setContextProperty("fileNames",  QVariant::fromValue(fileNames) );
     return;
     }
   loadHeadings();
   QVariant returnedValue;
   QVariant listNr = 2;
   QMetaObject::invokeMethod((QObject*)rootObject(), "setAtBegin", Qt::DirectConnection,
     Q_RETURN_ARG(QVariant, returnedValue),
     Q_ARG(QVariant, listNr));
   if (! returnedValue.toBool())
    {
    //for debugging
    }
   }
  else //one check is been (un)checked; reload all the items
   {
   loadItems(false);
   QVariant returnedValue;
   QVariant listNr = 2;
   QVariant nr = currentIndex;
   QMetaObject::invokeMethod((QObject*)rootObject(), "setInMid",
     Q_RETURN_ARG(QVariant, returnedValue),
     Q_ARG(QVariant, listNr),
     Q_ARG(QVariant, nr));
   if (! returnedValue.toBool())
    {
    //for debugging
    }
   }
 }
else
 {
 //for debugging
 }
}

bool MyQQuickView::loadCheckListsAllOverview()//read only, for showing a list of aircrafts
{
  QDir dp(QDir::homePath() + "/checklistsdata");//
  fileNames.clear();
  if(! ( (dp.exists()) && (dp.isReadable()) ) )
   {
   rootContext()->setContextProperty("fileNames",  QVariant::fromValue(fileNames) );//to avoid error message by MFiledialog that fileNames is not defined
   QVariant returnedValue;
   QVariant text = QString("FATAL ERROR:\nCANNOT LOAD CHECKLISTS\nOR CHECKLISTS ARE EMPTY.\nSHUTTING DOWN\n");
   QMetaObject::invokeMethod((QObject*)rootObject(), "errorDialog",
   Q_RETURN_ARG(QVariant, returnedValue), Q_ARG(QVariant, text));
   return false;
   }
  dp.setFilter(QDir::NoDotAndDotDot | QDir::Files);//
  QFileInfoList files = dp.entryInfoList();
  bool chked = false;
  for (long i = 0; i < files.size(); ++i)
   {
    fileNames.append(new CheckListItem(chked, files[i].fileName())) ;
   }

  if (fileNames.size() == 0)
  {
  rootContext()->setContextProperty("fileNames",  QVariant::fromValue(fileNames) );//to avoid error message by MFiledialog that fileNames is not defined
  QVariant returnedValue;
  QVariant text = QString("FATAL ERROR:\nCANNOT LOAD CHECKLISTS\nOR CHECKLISTS ARE EMPTY.\nSHUTTING DOWN\n");
  QMetaObject::invokeMethod((QObject*)rootObject(), "errorDialog",
  Q_RETURN_ARG(QVariant, returnedValue), Q_ARG(QVariant, text));
  shutDown();
  }
 rootContext()->setContextProperty("fileNames",  QVariant::fromValue(fileNames) );
 return true;
}

bool MyQQuickView::loadAndShowChecklists()//load the first checklists of one aircraft(type) into QML; the 'checkLists' var is already filled with all the aircrafts checklists
{
  QTextStream ss;
  QString zz("");
  ss.setString(&zz, QIODevice::ReadWrite);
  nrOfCheckedItems = 0;
  QStringList names;
  checkListHeadings.clear();
  QString clName;
  bool chked = false;
  currentHeadingIndex = 0;
  int index = 0;
  //first handle the the checklist headings (names) of this checklist-set (eg. cockpit-check, start-up, etc)
  for (int n = 0; n < checkLists.size(); ++n)
     {
     //fill the qml listview from here
     clName = checkLists.at(n).first;
     names << clName;
     checkHeadingVals << false;//set all headings to false
     checkListHeadings.append(new CheckListItem(chked, clName));
     index++;
     }
  totalNrOfheadings = index;
  rootContext()->setContextProperty("myCheckListHeadings",  QVariant::fromValue(checkListHeadings) );//data
  currentChecklist = checkLists.at(0).first;//currentChecklist=first checklist of this aircraft

  //now fill the checks of only the first checklist into QML (e.g. cockpit-check)
  ss << checkLists.at(0).second;
  QString line;
  bool chked1 = false;
  checkItems.clear();
  checkVals.clear();
  while (! ss.atEnd() )//fill the checklistviewer
      {
      line = ss.readLine();
         checkItems.append(new CheckListItem(chked1, line));//
         checkVals << false;//always (re)set to false
      }
  rootContext()->setContextProperty("myCheckListItems",  QVariant::fromValue(checkItems) );//data
  return true;
}

void MyQQuickView::loadHeadings()//now with different checked values; this happens intermediate to update QML heading colors
 {
  QStringList names;
  checkListHeadings.clear();
  QString clName;
    //first handle the keys
  for (int n = 0; n < checkLists.size(); ++n)
     {
     //fill the qml listview from here
     clName = checkLists.at(n).first;
     names << clName;
     checkListHeadings.append(new CheckListItem(checkHeadingVals[n], clName));//remember which headings were checked
     }
  rootContext()->setContextProperty("myCheckListHeadings",  QVariant::fromValue(checkListHeadings) );//data
  QVariant returnedValue;
  QVariant listNr = 1;
  QVariant nr = currentHeadingIndex;
  QMetaObject::invokeMethod((QObject*)rootObject(), "setInMid",
    Q_RETURN_ARG(QVariant, returnedValue),
    Q_ARG(QVariant, listNr),
    Q_ARG(QVariant, nr));
  if (! returnedValue.toBool())
   {
   //for debugging
   }
 }

void MyQQuickView::loadItems(bool clear)//now with different checked values; this happens intermediate to update QML check colors
 {
 checkItems.clear();
 if (clear)
  {//reset
  checkVals.clear();
  nrOfCheckedItems = 0;
  };
 QTextStream ss;
 QString zz("");
 ss.setString(&zz, QIODevice::ReadWrite);
 ss << checkLists.at(currentHeadingIndex).second;
 QString line;
 checkItems.clear();
 int index = 0;
 while (! ss.atEnd() )//fill the checklistviewer
     {
     line = ss.readLine();
     if (clear) {checkVals << false;}//refill with false
     checkItems.append(new CheckListItem(checkVals[index], line.replace(";", "\n")));//
     index++;
     }
    rootContext()->setContextProperty("myCheckListItems",  QVariant::fromValue(checkItems) );//data
 }
