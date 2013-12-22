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

#include "TVShowModel.h"

TVShowModel::TVShowModel(QObject *parent, int tvShowId) : Models::SubListedListItem(parent)
{
    this->m_tvShowId = tvShowId;
    this->seasonModels = new Models::SubListedListModel(new TVShowSeasonModel());
    this->m_season = 0;
    this->m_episode = 0;
    this->m_watchedEpisodes = 0;
}

TVShowModel::~TVShowModel()
{
    delete this->seasonModels;
    this->seasonModels = NULL;
}

int TVShowModel::id() const
{
    return this->m_tvShowId;
}

QVariant TVShowModel::data(int role) const
{
    switch (role)
    {
    case tvshowid:
        return this->id();
    case title:
        return this->getTitle();
    case year:
        return this->getYear();
    case rating:
        return this->getRating();
    case playcount:
        return this->getPlaycount();
    case episode:
        return this->getEpisode();
    case season:
        return this->getSeason();
    case watchedepisodes:
        return this->getWatchedEpisodes();
    case file:
        return this->getFile();
    case thumbnail:
        return this->getThumbnailUrl();
    case fanart:
        return this->getFanartUrl();
    case seasonsModel:
        return QVariant::fromValue(this->submodel());
    case plot:
        return this->getPlot();
    default:
        return QVariant();
    }
}

bool TVShowModel::setData(int role, const QVariant &value)
{
    switch(role)
    {
    case tvshowid:
        this->setTvShowId(value.toInt());
        return true;
    case title:
        this->setTitle(value.toString());
        return true;
    case year:
        this->setYear(value.toInt());
        return true;
    case rating:
        this->setRating(value.toInt());
        return true;
    case playcount:
        this->setPlaycount(value.toInt());
        return true;
    case episode:
        this->setEpisode(value.toInt());
        return true;
    case season:
        this->setSeason(value.toInt());
        return true;
    case watchedepisodes:
        this->setWatchedEpisodes(value.toInt());
        return true;
    case file:
        this->setFile(value.toString());
        return true;
    case thumbnail:
        this->setThumbnail(value.toString());
        return true;
    case fanart:
        this->setFanart(value.toString());
        return true;
    case plot:
        this->setPlot(value.toString());
        return true;
    default :
        return false;
    }
}

QHash<int, QByteArray> TVShowModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;

    roleNames[tvshowid] = "tvshowid";
    roleNames[title] = "title";
    roleNames[year] = "year";
    roleNames[rating] = "rating";
    roleNames[playcount] = "playcount";
    roleNames[episode] = "episode";
    roleNames[season] = "season";
    roleNames[watchedepisodes] = "watchedepisodes";
    roleNames[file] = "file";
    roleNames[thumbnail] = "thumbnail";
    roleNames[seasonsModel] = "seasonsModel";
    roleNames[plot] = "plot";
    roleNames[fanart] = "fanart";

    return roleNames;
}

Models::ListModel *TVShowModel::submodel() const
{
    return this->seasonModels;
}

Models::ListItem *TVShowModel::getNewItemInstance(QObject *parent) const
{
    return new TVShowModel(parent);
}

QString TVShowModel::getThumbnail() const
{
    return this->m_thumbnail;
}

QString TVShowModel::getFanart() const
{
    return this->m_fanArt;
}

QString TVShowModel::getPlot() const
{
    return this->m_plot;
}

QUrl TVShowModel::getThumbnailUrl() const
{
    return PlayableItemModel::formatImageUrl(this->m_thumbnail);
}

QUrl TVShowModel::getFanartUrl() const
{
    return PlayableItemModel::formatImageUrl(this->m_fanArt);
}

void TVShowModel::setThumbnail(const QString &thumbnail)
{
    this->m_thumbnail = thumbnail;
}

void TVShowModel::setFanart(const QString &fanart)
{
    this->m_fanArt = fanart;
}

QString TVShowModel::getTitle() const
{
    return this->m_title;
}

void TVShowModel::setTitle(const QString &title)
{
    this->m_title = title;
}

void TVShowModel::setPlot(const QString &plot)
{
    this->m_plot = plot;
}

QString TVShowModel::getFile() const
{
    return this->m_file;
}

void TVShowModel::setFile(const QString &file)
{
    this->m_file = file;
}

int TVShowModel::getWatchedEpisodes() const
{
    return this->m_watchedEpisodes;
}

void TVShowModel::setWatchedEpisodes(int watchedEpisodes)
{
    this->m_watchedEpisodes = watchedEpisodes;
}

int TVShowModel::getPlaycount() const
{
    return this->m_playcount;
}

void TVShowModel::setPlaycount(int playcount)
{
    this->m_playcount = playcount;
}

int TVShowModel::getEpisode() const
{
    return this->m_episode;
}

void TVShowModel::setEpisode(int episode)
{
    this->m_episode = episode;
}

int TVShowModel::getSeason() const
{
    return this->m_season;
}

void TVShowModel::setSeason(int season)
{
    this->m_season = season;
}

int TVShowModel::getRating() const
{
    return this->m_rating;
}

void TVShowModel::setRating(int rating)
{
    this->m_rating = rating;
}

int TVShowModel::getYear() const
{
    return this->m_year;
}

void TVShowModel::setYear(int year)
{
    this->m_year = year;
}

int TVShowModel::getTVShowId() const
{
    return this->m_tvShowId;
}

void TVShowModel::setTvShowId(int tvShowId)
{
    this->m_tvShowId = tvShowId;
}
