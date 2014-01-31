#ifndef PLAYERMODELITEM_H
#define PLAYERMODELITEM_H

#include <ListModel.h>
#include <SubListedListItem.h>
#include <PlayableItemModel.h>

class PlayerModelItem : public Models::SubListedListItem
{
    Q_OBJECT

public:

    enum PlayerModelItemEnum
    {
        playerid,
        playerType,
        playerItemsModel,
        playerPercentage,
        playerRepeat,
        playerSpeed
    };

    PlayerModelItem(QObject *parent = 0);
    virtual ~PlayerModelItem();
    PlayerModelItem &operator =(const PlayerModelItem &);

    // SubListedListItem interface
public:
    Models::ListModel *submodel() const;

    // ListItem interface
public:
    int id() const;
    QVariant data(int role) const;
    bool setData(int role, const QVariant &value);
    QHash<int, QByteArray> roleNames() const;
    Models::ListItem *getNewItemInstance(QObject *parent) const;


private :
    int m_playerId;
    QString m_playerType;
    Models::ListModel *m_playerPlayerItems;
    bool  m_playerRepeat;
    int   m_playerSpeed;
    float m_playerPercentage;

};

#endif // PLAYERMODELITEM_H
