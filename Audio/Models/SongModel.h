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

#ifndef SONGMODEL_H
#define SONGMODEL_H

#include <PlayableItemModel.h>

class SongModel : public PlayableItemModel
{
    Q_OBJECT
public:

    enum    SongModelItemRoles
    {
        songId = PlayableItemModel::thumbnail + 1,
        albumId,
        artistId,
        duration,
        track,
        genre
    };

    SongModel(QObject *parent = 0, int songId = -1);
    SongModel(const SongModel& song);
    ~SongModel();

    int             id() const;
    QVariant  data(int role) const;
    QHash<int, QByteArray>  roleNames() const;

    void setAlbumId(int albumId);
    void setArtistId(int artistId);
    void setDuration(int duration);
    void setTrack(int track);
    void setGenre(const QString &genre);

    int getAlbumId() const;
    int getArtistId() const;
    int getDuration() const;
    int getTrack() const;
    QString getGenre() const;


private:
    int             m_songId;
    int             m_albumId;
    int             m_artistId;
    int             m_duration;
    int             m_track;
    QString    m_genre;
};

#endif // SONGMODEL_H
