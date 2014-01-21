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

#include "VideoLibrary.h"
#include "JSONListItemBinder.h"

VideoLibrary::VideoLibrary(QObject *parent) : QObject(parent)
{
    this->webCallBacks[RETRIEVE_MOVIES] = &VideoLibrary::retrieveMoviesCallBack;
    this->webCallBacks[RETRIEVE_TVSHOWS] = &VideoLibrary::retrieveTVShowsCallBack;
    this->webCallBacks[RETRIEVE_TVSHOW_SEASONS] = &VideoLibrary::retrieveTVShowSeasonsCallBack;
    this->webCallBacks[RETRIEVE_TVSHOW_EPISODES] = &VideoLibrary::retrieveTVShowEpisodesCallBack;
    this->webCallBacks[REFRESH_VIDEO_LIBRARY] = &VideoLibrary::refreshVideoLibraryCallBack;

    this->databaseCallBacks[RETRIEVE_MOVIES] = &VideoLibrary::retrieveMoviesFromDBCallBack;
    this->databaseCallBacks[RETRIEVE_TVSHOWS] = &VideoLibrary::retrieveTVShowsFromDBCallBack;
    this->databaseCallBacks[RETRIEVE_TVSHOW_EPISODES] = &VideoLibrary::retrieveTVShowEpisodesFromDBCallBack;
    this->databaseCallBacks[RETRIEVE_TVSHOW_SEASONS] = &VideoLibrary::retrieveTVShowSeasonsFromDBCallBack;

    this->tvShowsLibraryModel = new Models::SubListedListModel(new TVShowModel());
    this->moviesLibraryModel = new Models::ListModel(new MovieModel());
    this->m_asyncRequests = 0;
    QObject::connect(this, SIGNAL(asyncRequestChanged()), this, SLOT(checkForRemoval()));
}

int VideoLibrary::getMajorIDRequestHandled() const
{
    return MAJOR_ID_REQUEST_VIDEO;
}

void VideoLibrary::receiveResultFromHttpRequest(QNetworkReply *reply, int id,  QPointer<QObject> data)
{
    (this->*this->webCallBacks[id])(reply, data);
}

int VideoLibrary::getMajorDBIDRequest() const
{
    return MAJOR_ID_REQUEST_VIDEO;
}

void VideoLibrary::receiveResultFromSQLQuery(QList<QSqlRecord> result, int requestId, QPointer<QObject> data)
{
    (this->*this->databaseCallBacks[requestId])(result, data);
}

void VideoLibrary::retrieveMovies(Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("VideoLibrary.GetMovies")));

    QJsonObject paramObj;
    QJsonObject sortObj;
    QJsonArray   properties;

    QHash<int, QByteArray> fields = dataModel->getPrototype()->roleNames();
    fields.remove(PlayableItemModel::streamingFile);
    fields.remove(MovieModel::movieId);
    fields.remove(PlayableItemModel::itemId);

    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));
    paramObj.insert("properties", QJsonValue(properties));
    sortObj.insert("order", QJsonValue(QString("ascending")));
    sortObj.insert("method", QJsonValue(QString("title")));
    paramObj.insert("sort", QJsonValue(sortObj));
    requestJson.insert("params", QJsonValue(paramObj));
    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("movies")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_MOVIES),  QPointer<QObject>(dataModel));
}

void VideoLibrary::retrieveTVShows(Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("VideoLibrary.GetTVShows")));

    QJsonObject paramObj;
    QJsonArray   properties;

    QHash<int, QByteArray> fields = dataModel->getPrototype()->roleNames();
    fields.remove(TVShowModel::tvshowid);
    fields.remove(TVShowModel::seasonsModel);
    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));

    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("tvshows")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_TVSHOWS),  QPointer<QObject>(dataModel));
}

void VideoLibrary::retrieveTVShowSeasons(int tvShowId, Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("VideoLibrary.GetSeasons")));

    QJsonObject paramObj;
    QJsonArray   properties;

    paramObj.insert("tvshowid", QJsonValue(tvShowId));
    QHash<int, QByteArray> fields = dataModel->getPrototype()->roleNames();
    fields.remove(TVShowSeasonModel::episodeModel);
    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("tvshows_seasons")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_TVSHOW_SEASONS), QPointer<QObject>(dataModel));
}

void VideoLibrary::retrieveTVShowEpisodes(int tvShowId, int season, Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("VideoLibrary.GetEpisodes")));

    QJsonObject paramObj;
    QJsonArray   properties;

    paramObj.insert("tvshowid", QJsonValue(tvShowId));
    paramObj.insert("season", QJsonValue(season));

    QHash<int, QByteArray> fields = dataModel->getPrototype()->roleNames();
    fields.remove(PlayableItemModel::streamingFile);
    fields.remove(PlayableItemModel::itemId);

    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));
    paramObj.insert("properties", QJsonValue(properties));

    requestJson.insert("params", QJsonValue(paramObj));
    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("tvshows")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_TVSHOW_EPISODES),  QPointer<QObject>(dataModel));
}

void VideoLibrary::refreshVideoLibrary()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("VideoLibrary.Scan")));

    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("refresh")));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, REFRESH_VIDEO_LIBRARY));
}

void VideoLibrary::reloadDataModels(bool webReload)
{
    // MODELS ARE SAVED IN CASE THEY ARE STILL SYNCHRONOUS REQUESTS GOING ON
    //    this->dirtyModelItem.append(this->moviesLibraryModel->takeRows());
    //    this->dirtyModelItem.append(this->tvShowsLibraryModel->takeRows());

    //    this->moviesLibraryModel->clear();
    //    this->tvShowsLibraryModel->clear();

    //    if (webReload)
    //    {
    //        this->retrieveMovies(this->moviesLibraryModel);
    //        this->retrieveTVShows(this->tvShowsLibraryModel);
    //    }
    //    else
    //    {
    //        this->retrieveMoviesFromDB();
    //        this->retrieveTVShowsFromDB();
    //    }
}


void VideoLibrary::saveShowsToDB()
{
    emit performSQLQuery("BEGIN;", 0);
    foreach (Models::ListItem *showItem, this->tvShowsLibraryModel->toList())
        this->saveShowToDB(reinterpret_cast<TVShowModel *>(showItem));
    emit performSQLQuery("COMMIT;", 0);
}

void VideoLibrary::saveShowToDB(TVShowModel *show)
{
    if (show != NULL)
    {
        QString insertShowQuery = QString("INSERT OR REPLACE INTO tv_serie "
                                          "(id, title, year, rating, playcount,"
                                          " watched_episodes, file, thumbnail, seasons, episodes)"
                                          " VALUES( %1, '%2', %3, %4, %5, %6, '%7', '%8', %9, %10);")
                .arg(QString::number(show->id()),
                     Utils::escapeSqlQuery(show->getTitle()),
                     QString::number(show->getYear()),
                     QString::number(show->getRating()),
                     QString::number(show->getPlaycount()),
                     QString::number(show->getWatchedEpisodes()))
                .arg( Utils::escapeSqlQuery(show->getFile()),
                      show->getThumbnail(),
                      QString::number(show->getSeason()),
                      QString::number(show->getEpisode()));
        emit performSQLQuery(insertShowQuery, 0);
        if (show->submodel())
            foreach (Models::ListItem *season, show->submodel()->toList())
                this->saveSeasonToDB(reinterpret_cast<TVShowSeasonModel *>(season));
    }
}

void VideoLibrary::saveSeasonToDB(TVShowSeasonModel *season)
{
    if (season != NULL)
    {
        QString insertSeasonQuery = QString("INSERT OR REPLACE INTO tv_serie_season "
                                            "(tv_serie_id, season_number, episodes, watched_episodes, thumbnail) "
                                            "VALUES ( %1, %2, %3, %4, '%5');")
                .arg(QString::number(season->getTVShowId()),
                     QString::number(season->id()),
                     QString::number(season->getEpisode()),
                     QString::number(season->getWatchedEpisodes()),
                     season->getThumbnail());
        emit performSQLQuery(insertSeasonQuery, 0);
        if (season->submodel())
            foreach (Models::ListItem *episode, season->submodel()->toList())
                this->saveEpisodeToDB(reinterpret_cast<TVShowEpisodeModel*>(episode));
    }
}

void VideoLibrary::saveEpisodeToDB(TVShowEpisodeModel *episode)
{
//    if (episode != NULL)
//    {
//        QString getSeasonId = QString("(SELECT id FROM tv_serie_season WHERE"
//                                      " tv_serie_id = %1 AND season_number = %2)")
//                .arg(QString::number(episode->getTVShowId()),
//                     QString::number(episode->getSeason()));

//        QString insertEpisodeQuery = QString("INSERT OR REPLACE INTO tv_serie_episode "
//                                             "(id, tv_serie_season_id, aired,"
//                                             " episode_number, summary, title, file, rating, thumbnail, runtime) VALUES("
//                                             " %1, %2,'%3', %4, '%5', '%6', '%7', %8, '%9', %10);")
//                .arg(QString::number(episode->id()),
//                     getSeasonId,
//                     episode->getAired(),
//                     QString::number(episode->getEpisodeNum()),
//                     Utils::escapeSqlQuery(episode->getSummary()))
//                .arg( Utils::escapeSqlQuery(episode->getTitle()),
//                      Utils::escapeSqlQuery(episode->getFile()),
//                      QString::number(episode->getRating()),
//                      episode->getThumbnail(),
//                      QString::number(episode->getRuntime()));
//        emit performSQLQuery(insertEpisodeQuery, 0);
//    }
}

void VideoLibrary::saveMoviesToDB()
{
    emit performSQLQuery("BEGIN;", 0);
    foreach (Models::ListItem *movie, this->moviesLibraryModel->toList())
        this->saveMovieToDB(reinterpret_cast<MovieModel *>(movie));
    emit performSQLQuery("COMMIT;", 0);
}

void VideoLibrary::saveMovieToDB(MovieModel *movie)
{
//    if (movie != NULL)
//    {
//        QString insertMovieQuery = QString("INSERT OR REPLACE INTO movie "
//                                           "(id, genre, mood, studio, year, plot, title, file, rating, thumbnail, runtime) "
//                                           "VALUES(%1, '%2', '%3', '%4', %5, '%6', '%7', '%8', %9, '%10', %11);")
//                .arg(QString::number(movie->id()),
//                     Utils::escapeSqlQuery(movie->getGenre()),
//                     Utils::escapeSqlQuery(movie->getMood()),
//                     Utils::escapeSqlQuery(movie->getStudio()),
//                     QString::number(movie->getYear()),
//                     Utils::escapeSqlQuery(movie->getPlot()))
//                .arg(Utils::escapeSqlQuery(movie->getTitle()),
//                     Utils::escapeSqlQuery(movie->getFile()),
//                     QString::number(movie->getRating()),
//                     movie->getThumbnail(),
//                     QString::number(movie->getRuntime()));

//        emit performSQLQuery(insertMovieQuery, 0);
//    }
}



void VideoLibrary::retrieveMoviesFromDB()
{
    QString selectMoviesQuery = QString("SELECT id, title, file,"
                                        " rating, thumbnail, runtime,"
                                        " genre, mood, studio,"
                                        " year, plot FROM movie ORDER BY title ASC;");
    emit performSQLQuery(selectMoviesQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_MOVIES));
}

void VideoLibrary::retrieveTVShowsFromDB()
{
    QString selectShowsQuery = QString("SELECT id, title, year, rating, playcount,"
                                       " watched_episodes, file, thumbnail, seasons, episodes"
                                       " FROM tv_serie ORDER BY title ASC;");
    emit performSQLQuery(selectShowsQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_TVSHOWS));
}

void VideoLibrary::retrieveTVShowSeasonsFromDB(TVShowModel *show)
{
    QString selectSeasonsQuery = QString("SELECT tv_serie_id, season_number,"
                                         " episodes, watched_episodes, thumbnail"
                                         " FROM tv_serie_season WHERE tv_serie_id = %1 ORDER BY season_number ASC;")
            .arg(QString::number(show->id()));
    emit performSQLQuery(selectSeasonsQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_TVSHOW_SEASONS), QPointer<QObject>(show));
}

void VideoLibrary::retrieveTVShowEpisodesFromDB(TVShowSeasonModel *season)
{
    QString getSeasonId = QString("(SELECT id FROM tv_serie_season WHERE"
                                  " tv_serie_id = %1 AND season_number = %2)")
            .arg(QString::number(season->getTVShowId()),
                 QString::number(season->id()));


    QString selectEpisodesQuery = QString("SELECT id, aired, episode_number,"
                                          " summary, title, file,"
                                          " rating, thumbnail, runtime FROM tv_serie_episode"
                                          " WHERE tv_serie_season_id = %1 ORDER BY episode_number ASC;")
            .arg(getSeasonId);
    emit performSQLQuery(selectEpisodesQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_VIDEO, RETRIEVE_TVSHOW_EPISODES), QPointer<QObject>(season));
}

Models::ListModel *VideoLibrary::getMoviesLibraryModel()
{
    this->moviesLibraryModel->clear();
    this->retrieveMovies(this->moviesLibraryModel);
    return this->moviesLibraryModel;
}

Models::ListModel *VideoLibrary::getTVShowsLibraryModel()
{
    this->tvShowsLibraryModel->clear();
    this->retrieveTVShows(this->tvShowsLibraryModel);
    return this->tvShowsLibraryModel;
}

void VideoLibrary::refreshSeasonsForShow(int showId)
{
    Models::SubListedListItem *item = NULL;
    if ((item = reinterpret_cast<Models::SubListedListItem*>
         (this->tvShowsLibraryModel->find(showId))) != NULL)
    {
        item->submodel()->clear();
        this->retrieveTVShowSeasons(showId, item->submodel());
    }
}

void VideoLibrary::retrieveMoviesFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (result.size() > 1)
    {
        result.pop_front();
        foreach (QSqlRecord record, result)
        {
            MovieModel *movie = new MovieModel(NULL, record.value(0).toInt());
            movie->setTitle(record.value(1).toString());
            movie->setFile(record.value(2).toString());
            movie->setRating(record.value(3).toInt());
            movie->setThumbnail(record.value(4).toString());
            movie->setRuntime(record.value(5).toInt());
            movie->setGenre(record.value(6).toString());
//            movie->setMood(record.value(7).toString());
            movie->setStudio(record.value(8).toString());
            movie->setYear(record.value(9).toInt());
            movie->setPlot(record.value(10).toString());

            this->moviesLibraryModel->appendRow(movie);
        }
    }
}

void VideoLibrary::retrieveTVShowsFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (result.size() > 1)
    {
        result.pop_front();
        foreach (QSqlRecord record, result)
        {
            TVShowModel *show = new TVShowModel(NULL, record.value(0).toInt());
            show->setTitle(record.value(1).toString());
            show->setYear(record.value(2).toInt());
            show->setRating(record.value(3).toInt());
            show->setPlaycount(record.value(4).toInt());
            show->setWatchedEpisodes(record.value(5).toInt());
            show->setFile(record.value(6).toString());
            show->setThumbnail(record.value(7).toString());
            show->setSeason(record.value(8).toInt());
            show->setEpisode(record.value(9).toInt());

            this->retrieveTVShowSeasonsFromDB(show);
            this->tvShowsLibraryModel->appendRow(show);
        }
    }
}

void VideoLibrary::retrieveTVShowSeasonsFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
    if (!data.isNull() && result.size() > 1)
    {
        result.pop_front();
        TVShowModel *show = reinterpret_cast<TVShowModel *>(data.data());
        foreach (QSqlRecord record, result)
        {
            TVShowSeasonModel *season = new TVShowSeasonModel(NULL, record.value(1).toInt());
            season->setTVShowId(show->id());
            season->setEpisode(record.value(2).toInt());
            season->setWatchedEpisodes(record.value(3).toInt());
            season->setThumbnail(record.value(4).toString());
            this->retrieveTVShowEpisodesFromDB(season);
            show->submodel()->appendRow(season);
        }
    }
}

void VideoLibrary::retrieveTVShowEpisodesFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
//    if (!data.isNull() && result.size() > 0)
//    {
//        result.pop_front();
//        TVShowSeasonModel *season = reinterpret_cast<TVShowSeasonModel *>(data.data());
//        foreach (QSqlRecord record, result)
//        {
//            TVShowEpisodeModel *episode = new TVShowEpisodeModel(NULL, record.value(0).toInt());
//            episode->setAired(record.value(1).toString());
//            episode->setEpisodeNum(record.value(2).toInt());
//            episode->setSummary(record.value(3).toString());
//            episode->setTitle(record.value(4).toString());
//            episode->setFile(record.value(5).toString());
//            episode->setRating(record.value(6).toInt());
//            episode->setThumbnail(record.value(7).toString());
//            episode->setRuntime(record.value(8).toInt());
//            episode->setSeason(season->id());
//            episode->setTVShowId(season->getTVShowId());
//            season->submodel()->appendRow(episode);
//        }
//    }
}

void VideoLibrary::retrieveMoviesCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
//            qDebug() << "Results " << jsonResponse.toJson();
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray  moviesArray;
            if (!resultObj.isEmpty())
            {
                moviesArray = resultObj.value("movies").toArray();
                foreach (QJsonValue movieObj, moviesArray)
                {
                    MovieModel *movie = new MovieModel();
                    Models::JSONListItemBinder::fromQJsonValue(movieObj, movie);
                    if (movie->id() != -1)
                        reinterpret_cast<Models::ListModel *>(data.data())->appendRow(movie);
                }
            }
        }
        this->decreaseAsyncRequest();
    }
}

void VideoLibrary::retrieveTVShowsCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
//            qDebug() << "Results " << jsonResponse.toJson();
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray  tvShowsArray;
            if (!resultObj.isEmpty())
            {
                tvShowsArray = resultObj.value("tvshows").toArray();
                foreach (QJsonValue tvShowObj, tvShowsArray)
                {
                    TVShowModel *tvShow = new TVShowModel();
                    Models::JSONListItemBinder::fromQJsonValue(tvShowObj, tvShow);
                    if (tvShow->id() != -1)
                       reinterpret_cast<Models::ListModel *>(data.data())->appendRow(tvShow);
                }
            }
        }
        this->decreaseAsyncRequest();
    }
}

void VideoLibrary::retrieveTVShowSeasonsCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
//            qDebug() << "Results " << jsonResponse.toJson();
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray  tvShowsSeasonsArray;
            if (!resultObj.isEmpty())
            {
                tvShowsSeasonsArray = resultObj.value("seasons").toArray();
                foreach (QJsonValue seasonObj, tvShowsSeasonsArray)
                {
                    TVShowSeasonModel *season = new TVShowSeasonModel();
                    Models::JSONListItemBinder::fromQJsonValue(seasonObj, season);
                    if (season->id() != -1)
                    {
                        this->retrieveTVShowEpisodes(season->getTVShowId(), season->id(), season->submodel());
                        reinterpret_cast<Models::ListModel *>(data.data())->appendRow(season);
                    }
                }
            }
        }
        this->decreaseAsyncRequest();
    }
}

void VideoLibrary::retrieveTVShowEpisodesCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
//            qDebug() << jsonResponse.toJson();
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray  tvShowEpisodesArray;
            if (!resultObj.isEmpty())
            {
                tvShowEpisodesArray = resultObj.value("episodes").toArray();
                foreach (QJsonValue episodeObj, tvShowEpisodesArray)
                {
                    TVShowEpisodeModel *episode = new TVShowEpisodeModel();
                    Models::JSONListItemBinder::fromQJsonValue(episodeObj, episode);
                    if (episode->id() != -1)
                        reinterpret_cast<Models::ListModel *>(data.data())->appendRow(episode);
                }
            }
        }
        this->decreaseAsyncRequest();
    }
}

void VideoLibrary::refreshVideoLibraryCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (reply != NULL)
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
            QString result = jsonResponse.object().value("result").toString();
            if (result.compare("OK") == 0)
                this->reloadDataModels(true);
        }
    }
}

void VideoLibrary::increaseAsyncRequest()
{
    this->m_asyncRequests++;
    emit asyncRequestChanged();
}

void VideoLibrary::decreaseAsyncRequest()
{
    this->m_asyncRequests--;
    emit asyncRequestChanged();
    if (this->m_asyncRequests == 0)
    {
        qDebug() << "Saving SHOWS AND MOVIES TO DB ******************************";
        emit performSQLQuery("DELETE FROM movie;", 0);
        emit performSQLQuery("DELETE FROM tv_serie_episode;", 0);
        emit performSQLQuery("DELETE FROM tv_serie_season;", 0);
        emit performSQLQuery("DELETE FROM tv_serie;", 0);
        this->saveShowsToDB();
        this->saveMoviesToDB();
    }
}

void VideoLibrary::checkForRemoval()
{
    if (this->m_asyncRequests == 0 && !this->dirtyModelItem.empty())
    {
        qDebug() << "Freeing Video Models >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..";
        foreach (QList<Models::ListItem *> dirtyList, this->dirtyModelItem)
        {
            qDebug() << "VIDEO TO RREMOVE : " << dirtyList.size();
            while (!dirtyList.empty())
                delete dirtyList.takeFirst();
        }
    }
}

