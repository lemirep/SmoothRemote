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

#ifndef AUDIOLIBRARY_H
#define AUDIOLIBRARY_H

#include <QPointer>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QHash>
#include "Utils.h"
#include "IWebRequestDispatcher.h"
#include "IDBDispatcher.h"
#include "SubListedListModel.h"
#include "AlbumModel.h"
#include "ArtistModel.h"
#include "SongModel.h"
#include <JSONListItemBinder.h>

#define MAJOR_ID_REQUEST_AUDIO 1
#define RETRIEVE_ALBUMS 0
#define RETRIEVE_ARTISTS 1
#define RETRIEVE_SONGS 2
#define REFRESH_AUDIO_LIBRARY 4

class AudioLibrary : public QObject, public IWebRequestDispatcher, public IDBDispatcher
{
    Q_OBJECT
public:
    AudioLibrary(QObject *parent = 0);

    int                       getMajorIDRequestHandled() const;
    void                      receiveResultFromHttpRequest(QNetworkReply *reply, int id, QPointer<QObject> data);

    int                       getMajorDBIDRequest() const;
    void                      receiveResultFromSQLQuery(QList<QSqlRecord> result, int requestId, QPointer<QObject> data);

    // WEB
    void                      retrieveAudioAlbums(Models::ListModel *dataModel);
    void                      retrieveAudioArtists(Models::ListModel *dataModel);
    void                      retrieveAllSongs(Models::ListModel *dataModel);
    void                      retrieveSongsForAlbum(int albumId, Models::ListModel *dataModel);
    void                      retrieveAlbumsForArtist(int artistId, Models::ListModel *dataModel);
    void                      refreshAudioLibrary();
    void                      reloadDataModels(bool webReload = false);
    void                      refreshAlbumsForArtist(int artistId);

    // DATABASRE
    void                      saveArtistsToDB();
    void                      saveArtistToDB(ArtistModel *artist);
    void                      saveAlbumToDB(AlbumModel *album);
    void                      saveSongToDB(SongModel *song);
    void                      retrieveAudioArtistsFromDB();
    void                      retrieveAudioAlbumsFromDB(ArtistModel *artist);
    void                      retrieveAudioSongFromDB(AlbumModel *album);

    Models::ListModel *       getArtistsLibraryModel();
    Models::ListModel *       getAlbumsLibraryModel() const;
    Models::ListModel *       getSongsLibraryModel() const;

private:

    QHash<int, void (AudioLibrary::*)(QNetworkReply *reply, QPointer<QObject> data)> webCallBacks;
    QHash<int , void (AudioLibrary::*)(QList<QSqlRecord>, QPointer<QObject> data)>   databaseCallBacks;

    Models::SubListedListModel  *artistsLibraryModel;
    Models::SubListedListModel  *albumsLibraryModel;
    Models::ListModel           *songsLibraryModel;
    Models::ListModel           *songsPlayListModel;

    // DATABASE CALLBACKS

    void                     retrieveAudioArtistsFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data);
    void                     retrieveAudioAlbumsFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data);
    void                     retrieveAudioSongFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data);

    // WEB CALLBACKS

    void                     retrieveAudioAlbumsCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                     retrieveAudioArtistsCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                     retrieveSongsCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                     refreshAudioLibraryCallBack(QNetworkReply *reply, QPointer<QObject> data);

    QJsonObject              getSongsRequestBaseJSON(Models::ListModel *dataModel);

    int                       m_asyncRequests;

    void                      increaseAsyncRequest();
    void                      decreaseAsyncRequest();

private slots:
    void                      checkForRemoval();

signals:
    void                     performJsonRPCRequest(const QJsonObject &request, int requestId, QPointer<QObject> data = QPointer<QObject>());
    void                     asyncRequestChanged();
    void                     performSQLQuery(const QString &query, int requestId, QPointer<QObject> data = QPointer<QObject>());

};

#endif // AUDIOLIBRARY_H
