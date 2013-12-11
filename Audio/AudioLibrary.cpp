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

#include "AudioLibrary.h"
#include <QDebug>

AudioLibrary::AudioLibrary(QObject *parent) : QObject(parent)
{
    this->webCallBacks[RETRIEVE_ALBUMS] = &AudioLibrary::retrieveAudioAlbumsCallBack;
    this->webCallBacks[RETRIEVE_ARTISTS] = &AudioLibrary::retrieveAudioArtistsCallBack;
    this->webCallBacks[RETRIEVE_SONGS] = &AudioLibrary::retrieveSongsCallBack;
    this->webCallBacks[REFRESH_AUDIO_LIBRARY] = &AudioLibrary::refreshAudioLibraryCallBack;

    this->databaseCallBacks[RETRIEVE_ALBUMS] = &AudioLibrary::retrieveAudioAlbumsFromDBCallBack;
    this->databaseCallBacks[RETRIEVE_ARTISTS] = &AudioLibrary::retrieveAudioArtistsFromDBCallBack;
    this->databaseCallBacks[RETRIEVE_SONGS] = &AudioLibrary::retrieveAudioSongFromDBCallBack;

    this->artistsLibraryModel = new Models::SubListedListModel(new ArtistModel());
    this->albumsLibraryModel = new Models::SubListedListModel(new AlbumModel());
    this->songsLibraryModel = new Models::ListModel(new SongModel());

    this->m_asyncRequests = 0;

    QObject::connect(this, SIGNAL(asyncRequestChanged()), this, SLOT(checkForRemoval()));
}

int AudioLibrary::getMajorIDRequestHandled() const
{
    return MAJOR_ID_REQUEST_AUDIO;
}

void AudioLibrary::receiveResultFromHttpRequest(QNetworkReply *reply, int id, QPointer<QObject> data)
{
    (this->*this->webCallBacks[id])(reply, data);
}

int AudioLibrary::getMajorDBIDRequest() const
{
    return MAJOR_ID_REQUEST_AUDIO;

}

void AudioLibrary::receiveResultFromSQLQuery(QList<QSqlRecord> result, int requestId, QPointer<QObject> data)
{
    (this->*this->databaseCallBacks[requestId])(result, data);
}


void AudioLibrary::retrieveAudioAlbums(Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("AudioLibrary.GetAlbums")));

    QJsonObject paramObj;
    QJsonArray   properties;
    QJsonObject sortObj;

    properties.prepend(QJsonValue(QString("title")));
    properties.prepend(QJsonValue(QString("artistid")));
    properties.prepend(QJsonValue(QString("description")));
    properties.prepend(QJsonValue(QString("genre")));
    properties.prepend(QJsonValue(QString("rating")));
    properties.prepend(QJsonValue(QString("thumbnail")));
    properties.prepend(QJsonValue(QString("year")));
    properties.prepend(QJsonValue(QString("mood")));
    sortObj.insert("order", QJsonValue(QString("ascending")));
    sortObj.insert("method", QJsonValue(QString("album")));
    paramObj.insert("properties", QJsonValue(properties));

    requestJson.insert("params", QJsonValue(paramObj));
    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("albums")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_ALBUMS), QPointer<QObject>(dataModel));
}

void AudioLibrary::retrieveAudioArtists(Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("AudioLibrary.GetArtists")));

    QJsonObject paramObj;
    QJsonArray   properties;
    QJsonObject sortObj;

    properties.prepend(QJsonValue(QString("thumbnail")));
    properties.prepend(QJsonValue(QString("born")));
    properties.prepend(QJsonValue(QString("mood")));
    properties.prepend(QJsonValue(QString("genre")));
    sortObj.insert("order", QJsonValue(QString("ascending")));
    sortObj.insert("method", QJsonValue(QString("artist")));
    paramObj.insert("properties", QJsonValue(properties));
    paramObj.insert("sort", QJsonValue(sortObj));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(QString("artists")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_ARTISTS), QPointer<QObject>(dataModel));
}

void AudioLibrary::retrieveAllSongs(Models::ListModel *dataModel)
{
    QJsonObject requestJson = this->getSongsRequestBaseJSON();
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_SONGS), QPointer<QObject>(dataModel));
}

void AudioLibrary::retrieveSongsForAlbum(int albumId, Models::ListModel *dataModel)
{
    QJsonObject requestJson = this->getSongsRequestBaseJSON();
    QJsonObject params = requestJson.take("params").toObject();
    QJsonObject filter;

    filter.insert("albumid", QJsonValue(albumId));
    params.insert("filter", QJsonValue(filter));
    requestJson.insert("params", QJsonValue(params));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_SONGS), QPointer<QObject>(dataModel));
}

void AudioLibrary::retrieveAlbumsForArtist(int artistId, Models::ListModel *dataModel)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("AudioLibrary.GetAlbums")));

    QJsonObject paramObj;
    QJsonArray   properties;
    QJsonObject filter;

    filter.insert("artistid", QJsonValue(artistId));
    properties.prepend(QJsonValue(QString("title")));
    properties.prepend(QJsonValue(QString("artistid")));
    properties.prepend(QJsonValue(QString("description")));
    properties.prepend(QJsonValue(QString("genre")));
    properties.prepend(QJsonValue(QString("rating")));
    properties.prepend(QJsonValue(QString("thumbnail")));
    properties.prepend(QJsonValue(QString("year")));
    properties.prepend(QJsonValue(QString("mood")));

    paramObj.insert("filter", QJsonValue(filter));
    paramObj.insert("properties", QJsonValue(properties));

    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(QString("albums")));
    this->increaseAsyncRequest();
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_ALBUMS), QPointer<QObject>(dataModel));
}

void AudioLibrary::refreshAudioLibrary()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("AudioLibrary.Scan")));

    // "ID IS TRANSMITTED BACK WITH RESPONSE TO IDENTITFY THE QUERY
    requestJson.insert("id", QJsonValue(QString("refreshAudio")));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, REFRESH_AUDIO_LIBRARY));
}

void AudioLibrary::reloadDataModels(bool webReload)
{
    // MODELS ARE SAVED IN CASE THEY ARE STILL SYNCHRONOUS REQUESTS GOING ON
    this->songsLibraryModel->takeRows().clear();
    this->albumsLibraryModel->takeRows().clear();
    this->artistsLibraryModel->clear();

    //    ARTISTS RETURN ALBUMS THAT RETURN SONGS SO WE CAN FILL ALL OF THEM IN ONE PASS
    //    WHEN ALL REQUESTS HAVE BEEN ANSWERED
    if (webReload)
        this->retrieveAudioArtists(this->artistsLibraryModel);
    else
        this->retrieveAudioArtistsFromDB();
}

void AudioLibrary::saveArtistsToDB()
{
    emit performSQLQuery("BEGIN;", 0);
    foreach (Models::ListItem *artist, this->artistsLibraryModel->toList())
        this->saveArtistToDB(reinterpret_cast<ArtistModel *>(artist));
    emit performSQLQuery("COMMIT;", 0);
}

void AudioLibrary::saveArtistToDB(ArtistModel *artist)
{
    if (artist != NULL)
    {
        QString insertArtistQuery = QString("INSERT OR REPLACE INTO artist "
                                            "(id, genre, mood, name, thumbnail, birthdate) "
                                            "VALUES(%1, '%2', '%3', '%4', '%5', '%6');")
                .arg(QString::number(artist->id()),
                     Utils::escapeSqlQuery(artist->getGenre()),
                     Utils::escapeSqlQuery(artist->getMood()),
                     Utils::escapeSqlQuery(artist->getArtistName()),
                     Utils::escapeSqlQuery(artist->getThumbnail()),
                     Utils::escapeSqlQuery(artist->getBirthDate()));

        emit performSQLQuery(insertArtistQuery, 0);
        foreach (Models::ListItem *album, artist->submodel()->toList())
            this->saveAlbumToDB(reinterpret_cast<AlbumModel *>(album));
    }
}

void AudioLibrary::saveAlbumToDB(AlbumModel *album)
{
    if (album != NULL)
    {
        QString insertAlbumQuery = QString("INSERT OR REPLACE INTO album "
                                           " (id, artist_id, year, rating, title,"
                                           " genre, mood, thumbnail, description) "
                                           " VALUES(%1, %2, %3, %4, '%5', '%6', '%7', '%8', '9');")
                .arg(QString::number(album->id()),
                     QString::number(album->getArtistId()),
                     QString::number(album->getAlbumYear()),
                     QString::number(album->getRating()),
                     Utils::escapeSqlQuery(album->getAlbumTitle()),
                     Utils::escapeSqlQuery(album->getGenre()),
                     Utils::escapeSqlQuery(album->getMood()),
                     Utils::escapeSqlQuery(album->getThumbnail()),
                     Utils::escapeSqlQuery(album->getDescription()));
        emit performSQLQuery(insertAlbumQuery, 0);
        foreach (Models::ListItem *song, album->submodel()->toList())
            this->saveSongToDB(reinterpret_cast<SongModel *>(song));
    }
}

void AudioLibrary::saveSongToDB(SongModel *song)
{
    if (song != NULL)
    {
        QString insertSongQuery = QString("INSERT OR REPLACE INTO song "
                                          "(id, album_id, duration, track, rating, title, genre, file, thumbnail) "
                                          "VALUES(%1, %2, %3, %4, %5, '%6', '%7', '%8', '%9');")
                .arg(QString::number(song->id()),
                     QString::number(song->getAlbumId()),
                     QString::number(song->getDuration()),
                     QString::number(song->getTrack()),
                     QString::number(song->getRating()),
                     Utils::escapeSqlQuery(song->getTitle()),
                     Utils::escapeSqlQuery(song->getGenre()),
                     Utils::escapeSqlQuery(song->getFile()),
                     Utils::escapeSqlQuery(song->getThumbnail()));

        emit performSQLQuery(insertSongQuery, 0);
    }
}

void AudioLibrary::retrieveAudioArtistsFromDB()
{
    QString selectArtistsQuery = QString("SELECT id, genre, mood, name, thumbnail, birthdate "
                                    "FROM artist ORDER BY name ASC;");
    emit performSQLQuery(selectArtistsQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_ARTISTS));
}

void AudioLibrary::retrieveAudioAlbumsFromDB(ArtistModel *artist)
{
    QString selectAlbumQuery = QString("SELECT id, artist_id, year, rating, "
                                       "title, genre, mood, thumbnail, description "
                                       "FROM album WHERE artist_id = %1 ORDER BY year ASC;")
            .arg(artist->id());
    emit performSQLQuery(selectAlbumQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_ALBUMS), QPointer<QObject>(artist));
}

void AudioLibrary::retrieveAudioSongFromDB(AlbumModel *album)
{
    QString selectSongQuery = QString("SELECT id, album_id, duration, track, rating, "
                                      "genre, file, thumbnail, title FROM song "
                                      "WHERE album_id = %1 ORDER BY track ASC")
            .arg(album->id());
    emit performSQLQuery(selectSongQuery, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_AUDIO, RETRIEVE_SONGS), QPointer<QObject>(album));
}

Models::ListModel *AudioLibrary::getArtistsLibraryModel() const
{
    return this->artistsLibraryModel;
}

Models::ListModel *AudioLibrary::getAlbumsLibraryModel() const
{
    return this->albumsLibraryModel;
}

Models::ListModel *AudioLibrary::getSongsLibraryModel() const
{
    return this->songsLibraryModel;
}

void AudioLibrary::retrieveAudioArtistsFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (result.size() > 1)
    {
        result.pop_front();
        foreach (QSqlRecord record, result)
        {
            ArtistModel *artist = new ArtistModel(NULL, record.value(0).toInt());
            artist->setGenre(record.value(1).toString());
            artist->setMood(record.value(2).toString());
            artist->setArtistName(record.value(3).toString());
            artist->setThumbnail(record.value(4).toString());
            artist->setBirthDate(record.value(5).toString());

            this->retrieveAudioAlbumsFromDB(artist);
            this->artistsLibraryModel->appendRow(artist);
        }
    }
}

void AudioLibrary::retrieveAudioAlbumsFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
    if (!data.isNull() && result.size() > 1)
    {
        result.pop_front();
        ArtistModel *artist = reinterpret_cast<ArtistModel *>(data.data());
        foreach (QSqlRecord record, result)
        {
            AlbumModel *album = new AlbumModel(NULL, record.value(0).toInt());
            album->setArtistId(record.value(1).toInt());
            album->setAlbumYear(record.value(2).toInt());
            album->setRating(record.value(3).toInt());
            album->setAlbumTitle(record.value(4).toString());
            album->setGenre(record.value(5).toString());
            album->setMood(record.value(6).toString());
            album->setThumbnail(record.value(7).toString());
            album->setDescription(record.value(8).toString());

            this->retrieveAudioSongFromDB(album);
            artist->submodel()->appendRow(album);
            this->albumsLibraryModel->appendRow(album);
        }
    }
}

void AudioLibrary::retrieveAudioSongFromDBCallBack(QList<QSqlRecord> result, QPointer<QObject> data)
{
    if (!data.isNull() && result.size() > 1)
    {
        result.pop_front();
        AlbumModel *album = reinterpret_cast<AlbumModel *>(data.data());
        foreach (QSqlRecord record, result)
        {
            SongModel *song = new SongModel(NULL, record.value(0).toInt());
            song->setAlbumId(record.value(1).toInt());
            song->setDuration(record.value(2).toInt());
            song->setTrack(record.value(3).toInt());
            song->setRating(record.value(4).toInt());
            song->setGenre(record.value(5).toString());
            song->setFile(record.value(6).toString());
            song->setThumbnail(record.value(7).toString());
            song->setTitle(record.value(8).toString());
            album->submodel()->appendRow(song);
            this->songsLibraryModel->appendRow(song);
        }
    }
}

void AudioLibrary::retrieveAudioAlbumsCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray   albumsArray;

            if (!resultObj.isEmpty())
            {
                albumsArray = resultObj.value("albums").toArray();
                foreach (QJsonValue albumObj, albumsArray)
                {
                    AlbumModel *album = this->parseJsonAlbum(albumObj.toObject());
                    if (album != NULL)
                    {
                        reinterpret_cast<Models::ListModel*>(data.data())->appendRow(album);
                        this->retrieveSongsForAlbum(album->id(), album->submodel());
                    }
                }
            }
        }
        this->decreaseAsyncRequest();
    }
}

void AudioLibrary::retrieveAudioArtistsCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray  artistsArray;
            if (!resultObj.isEmpty())
            {
                artistsArray = resultObj.value("artists").toArray();
                foreach (QJsonValue artistObj, artistsArray)
                {
                    ArtistModel* artist = this->parseJsonArtist(artistObj.toObject());
                    if (artist != NULL)
                    {
                        reinterpret_cast<Models::ListModel*>(data.data())->appendRow(artist);
                        this->retrieveAlbumsForArtist(artist->id(), artist->submodel());
                    }
                }
            }
        }
        this->decreaseAsyncRequest();
    }
}

void AudioLibrary::retrieveSongsCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonResponse = Utils::QJsonDocumentFromReply(reply);
        if (!jsonResponse.isNull() && !jsonResponse.isEmpty() && jsonResponse.isObject())
        {
            QJsonObject resultObj = jsonResponse.object().value("result").toObject();
            QJsonArray songsArray;
            if (!resultObj.empty())
            {
                songsArray = resultObj.value("songs").toArray();
                foreach (QJsonValue songObj, songsArray)
                {
                    SongModel*  song = this->parseJsonSong(songObj.toObject());
                    if (song != NULL)
                        reinterpret_cast<Models::ListModel*>(data.data())->appendRow(song);
                    else
                        qDebug() << "Song is NULL";
                }
            }
            else
            {
                qDebug() << "Not expected json song";
                qDebug() << jsonResponse.toJson();
            }
        }
        this->decreaseAsyncRequest();
    }
}

void AudioLibrary::refreshAudioLibraryCallBack(QNetworkReply *reply,  QPointer<QObject> data)
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

QJsonObject AudioLibrary::getSongsRequestBaseJSON( )
{
    QJsonObject requestJson;
    QJsonObject paramObj;
    QJsonArray   properties;

    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("AudioLibrary.GetSongs")));

    properties.prepend(QJsonValue(QString("title")));
    properties.prepend(QJsonValue(QString("artist")));
    properties.prepend(QJsonValue(QString("genre")));
    properties.prepend(QJsonValue(QString("rating")));
    properties.prepend(QJsonValue(QString("track")));
    properties.prepend(QJsonValue(QString("duration")));
    properties.prepend(QJsonValue(QString("thumbnail")));
    properties.prepend(QJsonValue(QString("file")));
    properties.prepend(QJsonValue(QString("artistid")));
    properties.prepend(QJsonValue(QString("albumid")));

    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(QString("songs")));

    return requestJson;
}

AlbumModel *AudioLibrary::parseJsonAlbum(const QJsonObject &jsonAlbum)
{
    if (!jsonAlbum.isEmpty())
    {
        AlbumModel *album = new AlbumModel(NULL, jsonAlbum.value("albumid").toDouble());
        album->setArtistId(jsonAlbum.value("artistid").toArray().first().toDouble());
        album->setDescription(jsonAlbum.value("description").toString());
        album->setGenre(jsonAlbum.value("genre").toArray().first().toString());
        album->setMood(jsonAlbum.value("mood").toArray().first().toString());
        album->setAlbumTitle(jsonAlbum.value("title").toString());
        album->setRating(jsonAlbum.value("rating").toDouble());
        album->setAlbumYear((jsonAlbum.value("year").toDouble()));
        album->setThumbnail(jsonAlbum.value("thumbnail").toString());
        return album;
    }
    return NULL;
}

ArtistModel *AudioLibrary::parseJsonArtist(const QJsonObject &jsonArtist)
{
    if (!jsonArtist.isEmpty())
    {
        ArtistModel *artist = new ArtistModel(NULL, jsonArtist.value("artistid").toDouble());
        artist->setArtistName(jsonArtist.value("artist").toString());
        artist->setBirthDate(jsonArtist.value("born").toString());
        artist->setGenre(jsonArtist.value("genre").toArray().first().toString());
        artist->setMood(jsonArtist.value("mood").toArray().first().toString());
        artist->setThumbnail(jsonArtist.value("thumbnail").toString());
        return artist;
    }
    return NULL;
}

SongModel *AudioLibrary::parseJsonSong(const QJsonObject &jsonSong)
{
    if (!jsonSong.isEmpty())
    {
        SongModel *song = new SongModel(NULL, jsonSong.value("songid").toDouble());
        song->setAlbumId(jsonSong.value("albumid").toDouble());
        song->setArtistId(jsonSong.value("artistid").toArray().first().toDouble());
        song->setDuration(jsonSong.value("duration").toDouble());
        song->setRuntime(jsonSong.value("duration").toDouble());
        song->setFile(jsonSong.value("file").toString());
        song->setGenre(jsonSong.value("genre").toArray().first().toString());
        song->setRating(jsonSong.value("rating").toDouble());
        song->setThumbnail(jsonSong.value("thumbnail").toString());
        song->setTitle(jsonSong.value("title").toString());
        song->setTrack(jsonSong.value("track").toDouble());
        return song;
    }
    return NULL;
}

void AudioLibrary::increaseAsyncRequest()
{
    this->m_asyncRequests++;
    emit asyncRequestChanged();
}

void AudioLibrary::decreaseAsyncRequest()
{
    this->m_asyncRequests--;
    if (this->m_asyncRequests == 0)
    {
        emit performSQLQuery("DELETE FROM song;", 0);
        emit performSQLQuery("DELETE FROM album;", 0);
        emit performSQLQuery("DELETE FROM artist;", 0);
        this->saveArtistsToDB();
    }
    emit asyncRequestChanged();
}

void AudioLibrary::checkForRemoval()
{
    // ALL REQUESTS HAVE BEEN EMITTED AND RECEIVED
    // COPYINGS DATA FROM ARTIST MODELS TO ALBUM AND SONG MODELS
    if (this->m_asyncRequests == 0)
    {
        foreach (Models::ListItem *artistItem, this->artistsLibraryModel->toList())
        {
            ArtistModel *artist = reinterpret_cast<ArtistModel *>(artistItem);
            foreach (Models::ListItem *albumItem, artist->submodel()->toList())
            {
                AlbumModel *album = reinterpret_cast<AlbumModel *>(albumItem);
                this->albumsLibraryModel->appendRow(new AlbumModel(*album));
                foreach (Models::ListItem *songItem, album->submodel()->toList())
                {
                    SongModel *song = reinterpret_cast<SongModel *>(songItem);
                    this->songsLibraryModel->appendRow(new SongModel(*song));
                }
            }
        }
    }
}

