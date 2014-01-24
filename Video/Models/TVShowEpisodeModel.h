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

#ifndef TVSHOWEPISODEMODEL_H
#define TVSHOWEPISODEMODEL_H

#include <QUrl>
#include <PlayableItemModel.h>

class TVShowEpisodeModel : public PlayableItemModel
{
    Q_OBJECT
public:
    enum TVShowEpisodeModelItemRoles
    {
        episodeId = PlayableItemModel::thumbnail + 1,
        aired,
        summary,
        tvShowId,
        season,
        episodeNum
    };

    explicit TVShowEpisodeModel(QObject *parent = NULL, int episodeId = -1);
    ~TVShowEpisodeModel();

    int id() const;
    QVariant data(int role) const;
    bool     setData(int role, const QVariant &value);
    Models::ListItem *getNewItemInstance(QObject *parent) const;
    QHash<int, QByteArray> roleNames() const;

    QString getAired() const;
    QString getSummary() const;
    int getSeason() const;
    int getTVShowId() const;

    void setAired(const QString &aired);
    void setSummary(const QString &summary);
    void setSeason(int season);
    void setTVShowId(int tvShowId);


private:
    QString m_aired;
    QString m_summary;
    int m_tvShowId;
    int m_season;
    int m_episodeId;
    int m_episodeNum;

};

#endif // TVSHOWEPISODEMODEL_H
