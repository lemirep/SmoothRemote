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

#ifndef MOVIEMODEL_H
#define MOVIEMODEL_H

#include <PlayableItemModel.h>
#include <QUrl>

class MovieModel : public PlayableItemModel
{
    Q_OBJECT
public:

    enum MovieModelItemRoles
    {
        movieId = PlayableItemModel::thumbnail + 1,
        genre,
        mood, //UNUSED
        studio,
        plot,
        year
    };

    explicit MovieModel(QObject *parent = 0, int movieId = -1);
    int id() const;
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;

    QString getGenre() const;
    QString getMood() const;
    QString getStudio() const;
    QString getPlot() const;
    int getYear() const;

    void setGenre(const QString &genre);
    void setMood(const QString &mood);
    void setStudio(const QString &studio);
    void setPlot(const QString &plot);
    void setYear(int year);


private:
    QString m_genre;
    QString m_mood;
    QString m_studio;
    QString m_plot;
    int m_year;
    int m_movieId;
};

#endif // MOVIEMODEL_H
