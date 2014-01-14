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

#include "AlbumModel.h"

AlbumModel::AlbumModel(QObject *parent, int albumId) : Models::SubListedListItem(parent)
{
    this->m_albumId = albumId;
    this->songModel = new Models::ListModel(new SongModel());
    this->m_mood = "";
    this->m_genre = "";
}

AlbumModel::AlbumModel(const AlbumModel &album) : Models::SubListedListItem(NULL)
{
    if (this != &album)
    {
        this->m_albumId = album.id();
        this->m_albumYear = album.getAlbumYear();
        this->m_rating = album.getRating();
        this->m_artistId = album.getArtistId();
        this->m_albumTitle = album.getAlbumTitle();
        this->m_genre = album.getGenre();
        this->m_mood = album.getMood();
        this->m_thumbnail = album.getThumbnail();
        this->m_description = album.getDescription();

        this->songModel = new Models::ListModel(new SongModel());
        foreach (Models::ListItem *listItem, album.submodel()->toList())
        {
            SongModel *copySong = new SongModel(*(reinterpret_cast<SongModel *>(listItem)));
            this->songModel->appendRow(copySong);
        }
    }
}

AlbumModel::~AlbumModel()
{
    if (this->songModel != NULL)
        delete this->songModel;
    this->songModel = NULL;
}

int AlbumModel::id() const
{
    return this->m_albumId;
}

QVariant AlbumModel::data(int role) const
{
    switch (role)
    {
    case year :
        return this->getAlbumYear();
    case rating:
        return this->getRating();
    case artistid:
        return this->getArtistId();
    case title:
        return this->getAlbumTitle();
    case genre:
        return this->getGenre();
    case mood:
        return this->getMood();
    case thumbnail:
        return this->getThumbnailUrl();
    case description:
        return this->getDescription();
    case albumId:
        return this->id();
    case fanart:
        return this->getFanartUrl();
    case songsModel:
        return QVariant::fromValue(this->submodel());
    default :
        return QVariant();
    }
}

bool AlbumModel::setData(int role, const QVariant &value)
{
    switch (role)
    {
    case albumId:
        this->m_albumId = value.toInt();
        return true;
    case year:
        this->setAlbumYear(value.toInt());
        return true;
    case rating:
       this->setRating(value.toInt());
        return true;
    case artistid:
        this->setArtistId(value.toInt());
        return true;
    case title:
        this->setAlbumTitle(value.toString());
        return true;
    case genre:
       this->setGenre(value.toString());
        return true;
    case mood :
        this->setMood(value.toString());
        return true;
    case thumbnail:
        this->setThumbnail(value.toString());
        return true;
    case description:
        this->setDescription(value.toString());
        return true;
    case fanart:
        this->setFanart(value.toString());
        return true;
    default:
        return false;
    }
}

QHash<int, QByteArray> AlbumModel::roleNames() const
{
    QHash<int, QByteArray>  roleNames;

    roleNames[albumId] = "albumid";
    roleNames[year] = "year";
    roleNames[rating] = "rating";
    roleNames[artistid] = "artistid";
    roleNames[title] = "title";
    roleNames[genre] = "genre";
    roleNames[mood] = "mood";
    roleNames[thumbnail] = "thumbnail";
    roleNames[description] = "description";
    roleNames[fanart] = "fanart";
    roleNames[songsModel] = "songsModel";

    return roleNames;
}

Models::ListModel *AlbumModel::submodel() const
{
    return this->songModel;
}

Models::ListItem *AlbumModel::getNewItemInstance(QObject *parent) const
{
    return new AlbumModel(parent);
}

int AlbumModel::getAlbumYear() const
{
    return this->m_albumYear;
}

void AlbumModel::setAlbumYear(int albumYear)
{
    this->m_albumYear = albumYear;
}

int AlbumModel::getRating() const
{
    return this->m_rating;
}

void AlbumModel::setRating(int rating)
{
    this->m_rating = rating;
}

int AlbumModel::getArtistId() const
{
    return this->m_artistId;
}

void AlbumModel::setArtistId(int artistId)
{
    this->m_artistId = artistId;
}

QString AlbumModel::getAlbumTitle() const
{
    return this->m_albumTitle;
}

void AlbumModel::setAlbumTitle(const QString &albumTitle)
{
    this->m_albumTitle = albumTitle;
}

QString AlbumModel::getGenre() const
{
    return this->m_genre;
}

void AlbumModel::setGenre(const QString &genre)
{
    this->m_genre = genre;
}

QString AlbumModel::getMood() const
{
    return this->m_mood;
}

void AlbumModel::setMood(const QString &mood)
{
    this->m_mood = mood;
}

QString AlbumModel::getThumbnail() const
{
    return this->m_thumbnail;
}

QUrl AlbumModel::getThumbnailUrl() const
{
    return PlayableItemModel::formatImageUrl(this->m_thumbnail, "Resources/empty_cd.png");
}

QString AlbumModel::getFanart() const
{
    return this->m_fanart;
}

QUrl AlbumModel::getFanartUrl() const
{
    return PlayableItemModel::formatImageUrl(this->m_fanart, "Resources/empty_cd.png");
}

void AlbumModel::setThumbnail(const QString &thumbnail)
{
    this->m_thumbnail = thumbnail;
}

void AlbumModel::setFanart(const QString &fanart)
{
    this->m_fanart = fanart;
}

QString AlbumModel::getDescription() const
{
    return this->m_description;
}

void AlbumModel::setDescription(const QString &description)
{
    this->m_description = description;
}
