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


#include "SongModel.h"

SongModel::SongModel(QObject *parent, int songId) : PlayableItemModel(parent)
{
    this->m_songId = songId;
    this->m_artistId = -1;
    this->m_albumId = -1;
}

SongModel::SongModel(const SongModel &song) : PlayableItemModel(song)
{
    if (&song != this)
    {
        this->m_songId = song.id();
        this->m_albumId = song.getAlbumId();
        this->m_artistId = song.getArtistId();
        this->m_duration = song.getDuration();
        this->m_track = song.getTrack();
        this->m_genre = song.getGenre();
    }
}

SongModel::~SongModel()
{
}

int SongModel::id() const
{
    return this->m_songId;
}

QVariant SongModel::data(int role) const
{
    switch (role)
    {
    case songId:
        return this->id();
    case albumId:
        return this->getAlbumId();
    case artistId:
        return this->getArtistId();
    case duration:
        return this->getDuration();
    case track:
        return this->getTrack();
    case genre:
        return this->getGenre();
    default:
        return PlayableItemModel::data(role);
    }
}

QHash<int, QByteArray> SongModel::roleNames() const
{
    QHash<int, QByteArray>  roleNames = PlayableItemModel::roleNames();

    roleNames[songId] = "songId";
    roleNames[albumId] = "albumId";
    roleNames[artistId] = "artistId";
    roleNames[duration] = "duration";
    roleNames[track] = "track";
    roleNames[genre] = "genre";

    return roleNames;
}

QString SongModel::getGenre() const
{
    return this->m_genre;
}

void SongModel::setGenre(const QString &genre)
{
    this->m_genre = genre;
}

int SongModel::getTrack() const
{
    return this->m_track;
}

void SongModel::setTrack(int track)
{
    this->m_track = track;
}

int SongModel::getDuration() const
{
    return this->m_duration;
}

void SongModel::setDuration(int duration)
{
    this->m_duration = duration;
}

int SongModel::getArtistId() const
{
    return this->m_artistId;
}

void SongModel::setArtistId(int artistId)
{
    this->m_artistId = artistId;
}

int SongModel::getAlbumId() const
{
    return this->m_albumId;
}

void SongModel::setAlbumId(int albumId)
{
    this->m_albumId = albumId;
}
