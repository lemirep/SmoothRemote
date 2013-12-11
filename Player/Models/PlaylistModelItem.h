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

#include <ListModel.h>
#include <SubListedListItem.h>
#include "PlayableItemModel.h"

class PlaylistModelItem : public Models::SubListedListItem
{
    Q_OBJECT
public :
    enum PlaylistModelItemRoles
    {
        playlistId = Qt::UserRole + 1,
        playlistTypeString
    };

    enum PlaylistTypes
    {
        Audio = 1,
        Video,
        Pictures
    };

private:

    int m_playlistId;
    QString       m_playlistTypeString;
    Models::ListModel *m_playlistItemsModel;

public :
    PlaylistModelItem(QObject *parent = 0);
    PlaylistModelItem(int playlistId, const QString& playlistTypeString, QObject *parent = 0);
    ~PlaylistModelItem();


    // SubListedListItem interface
public:
    Models::ListModel *submodel() const;

    // ListItem interface
public:
    int id() const;
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    QString       getPlaylistTypeString() const;
};
