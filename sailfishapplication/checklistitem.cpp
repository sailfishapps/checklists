#include "checklistitem.h"
//each instance is bool-Qstring pair to be fed to QML


CheckListItem::CheckListItem(const bool &checkedVal, const QString &checkText, QObject *parent):
QObject(parent), m_checkedVal(checkedVal), m_checkHeadItem(checkText)
{
}

void CheckListItem::setChecked(bool checkVal)
{
 m_checkedVal = checkVal;
}

bool CheckListItem::checked() const
{
 return m_checkedVal;
}

QString CheckListItem::checkItem() const
{
 return m_checkHeadItem;
}//


