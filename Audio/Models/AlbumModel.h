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

#ifndef ALBUMMODEL_H
#define ALBUMMODEL_H

#include <SongModel.h>
#include <ListModel.h>
#include <SubListedListItem.h>
#include <QUrl>

class AlbumModel : public Models::SubListedListItem
{
    Q_OBJECT
public:

    enum    AlbumModelItemRoles
    {
        year = Qt::UserRole + 1,
        rating,
        artistid,
        title,
        genre,
        mood,
        thumbnail,
        description,
        fanart,
        albumId,
        songsModel
    };

    explicit AlbumModel(QObject *parent = 0, int albumId = -1);
    AlbumModel(const AlbumModel &album);
    ~AlbumModel();

    int                 id() const;
    QVariant      data(int role) const;
    bool          setData(int role, const QVariant &value);
    QHash<int, QByteArray>  roleNames() const;
    Models::ListModel*  submodel() const;
    Models::ListItem *  getNewItemInstance(QObject *parent) const;

    QString getDescription() const;
    QString getThumbnail() const;
    QUrl    getThumbnailUrl() const;
    QString getFanart() const;
    QUrl    getFanartUrl() const;
    QString getMood() const;
    QString getGenre() const;
    QString getAlbumTitle() const;
    int getArtistId() const;
    int getRating() const;
    int getAlbumYear() const;

    void setDescription(const QString &description);
    void setThumbnail(const QString &thumbnail);
    void setFanart(const QString &fanart);
    void setMood(const QString &mood);
    void setGenre(const QString &genre);
    void setAlbumTitle(const QString &albumTitle);
    void setArtistId(int artistId);
    void setRating(int rating);
    void setAlbumYear(int albumYear);

private :
    int          m_albumId;
    int          m_albumYear;
    int          m_rating;
    int          m_artistId;
    QString m_albumTitle;
    QString m_genre;
    QString m_mood;
    QString m_thumbnail;
    QString m_fanart;
    QString m_description;

    Models::ListModel *songModel;

};

#endif // ALBUMMODEL_H
