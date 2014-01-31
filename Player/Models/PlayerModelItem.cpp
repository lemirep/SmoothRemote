#include "PlayerModelItem.h"

PlayerModelItem::PlayerModelItem(QObject *parent) : Models::SubListedListItem(parent),
    m_playerId(-1),
    m_playerType(""),
    m_playerPlayerItems(new Models::ListModel(new PlayableItemModel())),
    m_playerRepeat(false),
    m_playerPercentage(0),
    m_playerSpeed(0)
{
}

PlayerModelItem::~PlayerModelItem()
{
    delete this->m_playerPlayerItems;
}

Models::ListModel *PlayerModelItem::submodel() const
{
    return this->m_playerPlayerItems;
}

int PlayerModelItem::id() const
{
    return this->m_playerId;
}

QVariant PlayerModelItem::data(int role) const
{
    switch (role)
    {
    case playerid:
        return this->id();
    case playerType:
        return this->m_playerType;
    case playerItemsModel:
        return QVariant::fromValue(this->m_playerPlayerItems);
    case playerRepeat:
        return this->m_playerRepeat;
    case playerPercentage:
        return this->m_playerPercentage;
    case playerSpeed:
        return this->m_playerSpeed;
    default :
        return QVariant();
    }
}

bool PlayerModelItem::setData(int role, const QVariant &value)
{
    switch (role)
    {
    case playerid:
        this->m_playerId = value.toInt();
        return true;
    case playerType:
        this->m_playerType = value.toString();
        return true;
    case playerPercentage:
        this->m_playerPercentage = value.toDouble();
        return true;
    case playerRepeat:
        this->m_playerRepeat = (value.toString().compare("on") == 0);
        return true;
    case playerSpeed:
        this->m_playerSpeed = value.toInt();
        return true;
    default :
        return false;
    }
}

QHash<int, QByteArray> PlayerModelItem::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[playerid] = "playerid";
    roles[playerType] = "type";
    roles[playerItemsModel] = "playerItemsModel";
    roles[playerSpeed] = "speed";
    roles[playerRepeat] = "repeat";
    roles[playerPercentage] = "percentage";

    return roles;
}

Models::ListItem *PlayerModelItem::getNewItemInstance(QObject *parent) const
{
    return new PlayerModelItem(parent);
}

PlayerModelItem &PlayerModelItem::operator=(const PlayerModelItem &other)
{
    if (&other != this)
    {
        foreach (int role, this->roleNames().keys())
            if (role != playerItemsModel)
                this->setData(role, other.data(role));
    }
}
