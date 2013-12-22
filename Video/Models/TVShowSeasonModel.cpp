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

#include "TVShowSeasonModel.h"

TVShowSeasonModel::TVShowSeasonModel(QObject *parent, int seasonId) : Models::SubListedListItem(parent),
    m_season(seasonId),
    m_episodeModel(new Models::ListModel(new TVShowEpisodeModel()))
{
}

TVShowSeasonModel::~TVShowSeasonModel()
{
    delete this->m_episodeModel;
    this->m_episodeModel = NULL;
}

int TVShowSeasonModel::id() const
{
    return this->m_season;
}

QVariant TVShowSeasonModel::data(int role) const
{
    switch (role)
    {
    case season:
        return this->id();
    case watchedEpisodes:
        return this->watchedEpisodes;
    case tvShowId:
        return this->getTVShowId();
    case episode:
        return this->getEpisode();
    case thumbnail:
        return this->getThumbnailUrl();
    case episodeModel:
        return QVariant::fromValue(this->submodel());
    default:
        return QVariant();
    }
}

bool TVShowSeasonModel::setData(int role, const QVariant &value)
{
    switch(role)
    {
    case season:
        this->m_season = value.toInt();
        return true;
    case watchedEpisodes:
        this->setWatchedEpisodes(value.toInt());
        return true;
    case tvShowId:
        this->setTVShowId(value.toInt());
        return true;
    case episode:
        this->setEpisode(value.toInt());
        return true;
    case thumbnail:
        this->setThumbnail(value.toString());
        return true;
    case episodeModel:
        return false;
    default:
        return false;
    }
}

QHash<int, QByteArray> TVShowSeasonModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;

    roleNames[season] = "season";
    roleNames[watchedEpisodes] = "watchedepisodes";
    roleNames[tvShowId] = "tvshowid";
    roleNames[episode] = "episode";
    roleNames[thumbnail] = "thumbnail";
    roleNames[episodeModel] = "episodeModel";

    return roleNames;
}

Models::ListModel *TVShowSeasonModel::submodel() const
{
    return this->m_episodeModel;
}

Models::ListItem *TVShowSeasonModel::getNewItemInstance(QObject *parent) const
{
    return new TVShowSeasonModel(parent);
}

QString TVShowSeasonModel::getThumbnail() const
{
    return this->m_thumbnail;
}

QUrl TVShowSeasonModel::getThumbnailUrl() const
{
    return this->m_thumbnailUrl;
}

void TVShowSeasonModel::setThumbnail(const QString &thumbnail)
{
    this->m_thumbnail = thumbnail;
    this->m_thumbnailUrl = PlayableItemModel::formatImageUrl(this->m_thumbnail);
}

int TVShowSeasonModel::getEpisode() const
{
    return this->m_episode;
}

void TVShowSeasonModel::setEpisode(int episode)
{
    this->m_episode = episode;
}

int TVShowSeasonModel::getTVShowId() const
{
    return this->m_tvShowId;
}

void TVShowSeasonModel::setTVShowId(int tvShowId)
{
    this->m_tvShowId = tvShowId;
}

int TVShowSeasonModel::getWatchedEpisodes() const
{
    return this->m_watchedEpisodes;
}

void TVShowSeasonModel::setWatchedEpisodes(int watchedEpisodes)
{
    this->m_watchedEpisodes = watchedEpisodes;
}
