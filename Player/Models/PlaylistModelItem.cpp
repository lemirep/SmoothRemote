/****************************************************************************
**
** Copyright (C) Paul Lemire, Tepee3DTeam and/or its subsidiary(-ies).
** Contact: paul.lemire@epitech.eu
** Contact: tepee3d_2014@labeip.epitech.eu
**
** This file is part of the Tepee3D project
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
****************************************************************************/

#include "PlaylistModelItem.h"

PlaylistModelItem::PlaylistModelItem(QObject *parent) :
    Models::SubListedListItem(parent),
    m_playlistItemsModel(NULL),
    m_playlistTypeString(""),
    m_playlistId(-1)
{
}

PlaylistModelItem::PlaylistModelItem(int playlistId, const QString& playlistTypeString, QObject *parent)
    : Models::SubListedListItem(parent),
      m_playlistId(playlistId),
      m_playlistTypeString(playlistTypeString),
      m_playlistItemsModel(NULL)
{
    qDebug() << "Type " << this->m_playlistTypeString;
    qDebug() << "Id " << this->m_playlistId;
}


PlaylistModelItem::~PlaylistModelItem()
{
    delete this->m_playlistItemsModel;
}

Models::ListModel *PlaylistModelItem::submodel() const
{
    return this->m_playlistItemsModel;
}


int PlaylistModelItem::id() const
{
    return this->m_playlistId;
}

QVariant PlaylistModelItem::data(int role) const
{
    switch (role)
    {
    case playlistId:
        return this->id();
    case playlistTypeString:
        return this->getPlaylistTypeString();
    case playlistItemsModel:
        return QVariant::fromValue(this->submodel());
    default :
        return QVariant();
    }
}

bool PlaylistModelItem::setData(int role, const QVariant &value)
{
    switch (role)
    {
    case (playlistId):
        this->m_playlistId = value.toInt();
        return true;
    case (playlistTypeString):
        this->m_playlistTypeString = value.toString();
        this->m_playlistItemsModel = new Models::ListModel(
                    (this->m_playlistTypeString == "audio") ?
                         new SongModel(NULL):
                        new PlayableItemModel(NULL));
        return true;
    default :
        return false;
    }
}

QHash<int, QByteArray> PlaylistModelItem::roleNames() const
{
    QHash<int, QByteArray> roleNames;

    roleNames[playlistId] = "playlistid";
    roleNames[playlistTypeString] = "type";
    roleNames[playlistItemsModel] = "playlistItemsModel";

    return roleNames;
}

Models::ListItem *PlaylistModelItem::getNewItemInstance(QObject *parent) const
{
    return new PlayableItemModel(parent);
}

QString PlaylistModelItem::getPlaylistTypeString() const
{
    return this->m_playlistTypeString;
}

