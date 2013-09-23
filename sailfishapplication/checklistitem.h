#ifndef CHECKLISTITEM_H
#define CHECKLISTITEM_H
#include <QObject>
#include <QDebug>

class CheckListItem : public QObject
{
Q_OBJECT

    Q_PROPERTY(QString checkItem READ checkItem NOTIFY checkItemChanged)
    Q_PROPERTY(bool checked READ checked NOTIFY checkedChanged)

public:
    CheckListItem(const bool &checkedVal, const QString &check, QObject *parent=0);
    bool checked() const;
    QString checkItem() const;
    void setChecked(bool check);
private:
    bool m_checkedVal;
    QString m_checkHeadItem;
signals:
    bool checkedChanged();
    QString checkItemChanged();
};

#endif // CHECKLISTITEM_H
