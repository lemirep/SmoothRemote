#ifndef VIDEOLIBRARY_H
#define VIDEOLIBRARY_H

#include <QPointer>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <IWebRequestDispatcher.h>
#include <IDBDispatcher.h>
#include <ListModel.h>
#include "TVShowModel.h"
#include "MovieModel.h"
#include <Utils.h>
#include <QDebug>

#define MAJOR_ID_REQUEST_VIDEO 4
#define RETRIEVE_MOVIES 0
#define RETRIEVE_TVSHOWS 1
#define RETRIEVE_TVSHOW_SEASONS 2
#define RETRIEVE_TVSHOW_EPISODES 3
#define REFRESH_VIDEO_LIBRARY 4

class VideoLibrary : public QObject, public IWebRequestDispatcher, public IDBDispatcher
{
    Q_OBJECT
public:
    VideoLibrary(QObject *parent = 0);

    int                 getMajorIDRequestHandled()  const;
    void                receiveResultFromHttpRequest(QNetworkReply *reply, int id,  QPointer<QObject> data);

    int                 getMajorDBIDRequest() const;
    void                receiveResultFromSQLQuery(QList<QSqlRecord> result, int requestId, QPointer<QObject> data);

    // WEB

    void                retrieveMovies(Models::ListModel *dataModel);
    void                retrieveTVShows(Models::ListModel *dataModel);
    void                retrieveTVShowSeasons(int tvShowId, Models::ListModel *dataModel);
    void                retrieveTVShowEpisodes(int tvShowId, int season, Models::ListModel *dataModel);
    void                refreshVideoLibrary();
    void                reloadDataModels(bool webReload = false);

    // DATABASE

    void                saveShowsToDB();
    void                saveShowToDB(TVShowModel *show);
    void                saveSeasonToDB(TVShowSeasonModel *season);
    void                saveEpisodeToDB(TVShowEpisodeModel *episode);
    void                saveMoviesToDB();
    void                saveMovieToDB(MovieModel *movie);
    void                retrieveMoviesFromDB();
    void                retrieveTVShowsFromDB();
    void                retrieveTVShowSeasonsFromDB(TVShowModel *show);
    void                retrieveTVShowEpisodesFromDB(TVShowSeasonModel *season);

    Models::ListModel   *getMoviesLibraryModel();
    Models::ListModel   *getTVShowsLibraryModel();
    void                refreshSeasonsForShow(int showId);

private:

    QHash<int , void (VideoLibrary::*)(QNetworkReply *,  QPointer<QObject> data)>    webCallBacks;
    QHash<int , void (VideoLibrary::*)(QList<QSqlRecord>, QPointer<QObject> data)>   databaseCallBacks;

    Models::ListModel   *moviesLibraryModel;
    Models::ListModel   *tvShowsLibraryModel;
    int                       m_asyncRequests;
    QList< QList<Models::ListItem *> > dirtyModelItem;

    // DATABASE

    void                retrieveMoviesFromDBCallBack(QList<QSqlRecord>, QPointer<QObject> data);
    void                retrieveTVShowsFromDBCallBack(QList<QSqlRecord>, QPointer<QObject> data);
    void                retrieveTVShowSeasonsFromDBCallBack(QList<QSqlRecord>, QPointer<QObject> data);
    void                retrieveTVShowEpisodesFromDBCallBack(QList<QSqlRecord>, QPointer<QObject> data);

    // WEB CALLBACKS
    void                retrieveMoviesCallBack(QNetworkReply *reply,  QPointer<QObject> data);
    void                retrieveTVShowsCallBack(QNetworkReply *reply,  QPointer<QObject> data);
    void                retrieveTVShowSeasonsCallBack(QNetworkReply *reply,  QPointer<QObject>data);
    void                retrieveTVShowEpisodesCallBack(QNetworkReply *reply,  QPointer<QObject> data);
    void                refreshVideoLibraryCallBack(QNetworkReply *reply,  QPointer<QObject> data);

    TVShowModel         *parseTVShow(const QJsonObject& tvShowObj);
    TVShowSeasonModel   *parseTVShowSeason(const QJsonObject &tvShowSeasonObj);
    TVShowEpisodeModel  *parseTVShowEpisode(const QJsonObject &tvShowEpisodeObj);
    MovieModel          *parseMovie(const QJsonObject &movieObj);

    void                      increaseAsyncRequest();
    void                      decreaseAsyncRequest();
private slots:
    void                      checkForRemoval();

signals:
    void                performSQLQuery(const QString &query, int requestId, QPointer<QObject> data = QPointer<QObject>());
//    void                executeSQLQuery(const QString& query, QPointer<QObject> sender, int id, const QString &dbName, QPointer<QObject> data = QPointer<QObject>());
    void                performJsonRPCRequest(const QJsonObject &request, int requestId, QPointer<QObject> data = QPointer<QObject>());
    void                asyncRequestChanged();
};

#endif // VIDEOLIBRARY_H
