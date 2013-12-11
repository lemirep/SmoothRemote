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

#include "TVShowEpisodeModel.h"

TVShowEpisodeModel::TVShowEpisodeModel(QObject *parent, int episodeId) : PlayableItemModel(parent)
{
    this->m_episodeId = episodeId;
}

TVShowEpisodeModel::~TVShowEpisodeModel()
{
}

int TVShowEpisodeModel::id() const
{
    return this->m_episodeId;
}

QVariant TVShowEpisodeModel::data(int role) const
{
    switch (role)
    {
    case episodeId:
        return this->id();
    case aired:
        return this->getAired();
    case summary:
        return this->getSummary();
    case tvShowId:
        return this->getTVShowId();
    case season:
        return this->getSeason();
    case episodeNum:
        return this->getEpisodeNum();
    default:
        return PlayableItemModel::data(role);
    }
}

QHash<int, QByteArray> TVShowEpisodeModel::roleNames() const
{
    QHash<int, QByteArray> roleNames = PlayableItemModel::roleNames();
    roleNames[episodeId] = "episodeId";
    roleNames[aired] = "aired";
    roleNames[summary] = "summary";
    roleNames[tvShowId] = "tvShowId";
    roleNames[season] = "season";
    roleNames[episodeNum] = "episodeNum";
    return roleNames;
}

QString TVShowEpisodeModel::getSummary() const
{
    return this->m_summary;
}

void TVShowEpisodeModel::setSummary(const QString &summary)
{
    this->m_summary = summary;
}

QString TVShowEpisodeModel::getAired() const
{
    return this->m_aired;
}

void TVShowEpisodeModel::setAired(const QString &aired)
{
    this->m_aired = aired;
}


int TVShowEpisodeModel::getTVShowId() const
{
    return this->m_tvShowId;
}

void TVShowEpisodeModel::setTVShowId(int tvShowId)
{
    this->m_tvShowId = tvShowId;
}
int TVShowEpisodeModel::getEpisodeNum() const
{
    return this->m_episodeNum;
}

void TVShowEpisodeModel::setEpisodeNum(int episodeNum)
{
    this->m_episodeNum = episodeNum;
}

int TVShowEpisodeModel::getSeason() const
{
    return this->m_season;
}

void TVShowEpisodeModel::setSeason(int season)
{
    this->m_season = season;
}
