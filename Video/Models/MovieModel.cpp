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

#include "MovieModel.h"

MovieModel::MovieModel(QObject *parent, int movieId) : PlayableItemModel(parent)
{
    this->m_movieId = movieId;
}

int MovieModel::id() const
{
    return this->m_movieId;
}

QVariant MovieModel::data(int role) const
{
    switch (role)
    {
    case movieId:
        return this->id();
    case genre:
        return this->getGenre();
    case studio:
        return this->getStudio();
    case plot:
        return this->getPlot();
    case year:
        return this->getYear();
    default:
        return PlayableItemModel::data(role);
    }
}

bool MovieModel::setData(int role, const QVariant &value)
{
    switch (role)
    {
    case movieId:
        this->m_movieId = value.toInt();
        return true;
    case genre:
        this->setGenre(value.toString());
        return true;
    case studio:
        this->setStudio(value.toString());
        return true;
    case plot:
        this->setPlot(value.toString());
        return true;
    case year:
        this->setYear(value.toInt());
        return true;
    default:
        return PlayableItemModel::setData(role, value);
    }
}

Models::ListItem *MovieModel::getNewItemInstance(QObject *parent) const
{
    return new MovieModel(parent);
}

QHash<int, QByteArray> MovieModel::roleNames() const
{
    QHash<int, QByteArray> roleNames = PlayableItemModel::roleNames();

    roleNames[movieId] = "movieid";
    roleNames[genre] = "genre";
    roleNames[studio] = "studio";
    roleNames[plot] = "plot";
    roleNames[year] = "year";
    return roleNames;
}

int MovieModel::getYear() const
{
    return this->m_year;
}

void MovieModel::setYear(int year)
{
    this->m_year = year;
}

QString MovieModel::getPlot() const
{
    return this->m_plot;
}

void MovieModel::setPlot(const QString &plot)
{
    this->m_plot = plot;
}

QString MovieModel::getStudio() const
{
    return this->m_studio;
}

void MovieModel::setStudio(const QString &studio)
{
    this->m_studio = studio;
}

QString MovieModel::getGenre() const
{
    return this->m_genre;
}

void MovieModel::setGenre(const QString &genre)
{
    this->m_genre = genre;
}
