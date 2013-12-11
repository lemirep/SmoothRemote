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

#ifndef ARTISTMODEL_H
#define ARTISTMODEL_H

#include <SubListedListItem.h>
#include <SubListedListModel.h>
#include <ListModel.h>
#include <QUrl>
#include <AlbumModel.h>

class ArtistModel : public Models::SubListedListItem
{
    Q_OBJECT
public:

    enum    ArtistModelItemRoles
    {
        artistId = Qt::UserRole + 1,
        artistName,
        birthDate,
        genre,
        thumbnail,
        mood
    };

    ArtistModel(QObject *parent = 0, int artistId = -1);
    ~ArtistModel();

    int     id() const;
    QHash<int, QByteArray>    roleNames() const;
    QVariant        data(int role) const;
    Models::ListModel*  submodel() const;

    QString getArtistName() const;
    void setArtistName(const QString &artistName);

    QString getBirthDate() const;
    void setBirthDate(const QString &birthDate);

    QString getGenre() const;
    void setGenre(const QString &genre);

    QString getThumbnail() const;
    QUrl    getThumbnailUrl() const;
    void setThumbnail(const QString &thumbnail);

    QString getMood() const;
    void setMood(const QString &mood);

private:
    int     m_artistId;
    QString m_artistName;
    QString m_birthDate;
    QString m_genre;
    QString m_thumbnail;
    QUrl    m_thumbnailUrl;
    QString m_mood;

    Models::SubListedListModel   *albumsModel;
};

#endif // ARTISTMODEL_H
