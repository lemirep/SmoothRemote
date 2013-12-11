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

#ifndef TVSHOWSEASONMODEL_H
#define TVSHOWSEASONMODEL_H

#include <SubListedListItem.h>
#include <ListModel.h>
#include "TVShowEpisodeModel.h"

class TVShowSeasonModel : public Models::SubListedListItem
{
    Q_OBJECT
public:
    enum TVShowSeasonModelItemRoles
    {
        season = Qt::UserRole + 1,
        watchedEpisodes, //UNUSED
        tvShowId,
        episode,
        thumbnail
    };

    explicit TVShowSeasonModel(QObject *parent = 0, int seasonId = -1);
    ~TVShowSeasonModel();

    int     id() const;
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    Models::ListModel *submodel() const;

    int getWatchedEpisodes() const;
    int getTVShowId() const;
    int getEpisode() const;
    QString getThumbnail() const;
    QUrl    getThumbnailUrl() const;

    void setWatchedEpisodes(int watchedEpisodes);
    void setTVShowId(int tvShowId);
    void setEpisode(int episode);
    void setThumbnail(const QString &thumbnail);



private:
    int     m_season;
    int     m_watchedEpisodes;
    int     m_tvShowId;
    int     m_episode;
    QString m_thumbnail;
    QUrl    m_thumbnailUrl;
    Models::ListModel* episodeModel;
};

#endif // TVSHOWSEASONMODEL_H
