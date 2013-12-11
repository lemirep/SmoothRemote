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

#include "PlayerManager.h"
#include <QDebug>

PlayerManager::PlayerManager(QObject *parent) : QObject(parent)
{
    this->webCallBacks[GENERIC_CALLBACK] = &PlayerManager::genericCallBack;
    this->webCallBacks[GET_ACTIVE_PLAYERS] = &PlayerManager::getActivesPlayersCallBack;
    this->webCallBacks[GET_PLAYED_ITEM] = &PlayerManager::getCurrentlyPlayedItemCallBack;
    this->webCallBacks[GET_PLAYER_STATE] = &PlayerManager::getCurrentPlayerStateCallBack;
    this->webCallBacks[GET_PLAYLISTS] = &PlayerManager::getPlaylistsCallBack;
    this->webCallBacks[GET_PLAYLIST_ITEMS] = &PlayerManager::getPlaylistItemsCallBack;
    this->webCallBacks[EDITED_PLAYLIST] = &PlayerManager::playlistEditedCallBack;
    this->webCallBacks[PLAY_FILE] = &PlayerManager::playFileCallBack;
    this->currentActivePlayer = -1;
    this->currentlyPlayerItems = new Models::ListModel(new PlayableItemModel());
    this->playlistsModels = new Models::SubListedListModel(new PlaylistModelItem(NULL));
    this->isPlayging = false;
    this->playerAdvance = 0;
}

void PlayerManager::getActivesPlayers()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GetActivePlayers")));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_ACTIVE_PLAYERS));
}

void PlayerManager::playFile(const QString &file)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Open")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("file", QJsonValue(file));
    paramObj.insert("item", QJsonValue(fileObj));
    requestJson.insert("params", QJsonValue(paramObj));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, PLAY_FILE));
}

void PlayerManager::addFileToPlayList(const QString &file, const int playlistId)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Add")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("file", QJsonValue(file));
    paramObj.insert("item", QJsonValue(fileObj));
    paramObj.insert("playlistid", QJsonValue(playlistId));

    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}


void PlayerManager::addArtistToPlaylist(const int artistId)
{
    int playlistId = this->getAudioPlaylistId();
    if (playlistId == -1)
        return ;
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Add")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("artistid", QJsonValue(artistId));
    paramObj.insert("item", QJsonValue(fileObj));
    paramObj.insert("playlistid", QJsonValue(playlistId));

    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::addAlbumToPlaylist(const int albumId)
{
    int playlistId = this->getAudioPlaylistId();
    if (playlistId == -1)
        return ;
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Add")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("albumid", QJsonValue(albumId));
    paramObj.insert("item", QJsonValue(fileObj));
    paramObj.insert("playlistid", QJsonValue(playlistId));

    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::addSongToPlaylist(const int songId)
{
    int playlistId = this->getAudioPlaylistId();
    if (playlistId == -1)
        return ;
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Add")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("songid", QJsonValue(songId));
    paramObj.insert("item", QJsonValue(fileObj));
    paramObj.insert("playlistid", QJsonValue(playlistId));

    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::addMovieToPlaylist(const int movieId)
{
    int playlistId = this->getVideoPlaylistId();
    if (playlistId == -1)
        return ;
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Add")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("movieid", QJsonValue(movieId));
    paramObj.insert("item", QJsonValue(fileObj));
    paramObj.insert("playlistid", QJsonValue(playlistId));

    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::addEpisodeToPlaylist(const int episodeId)
{
    int playlistId = this->getVideoPlaylistId();
    if (playlistId == -1)
        return ;
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Add")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    fileObj.insert("episodedd", QJsonValue(episodeId));
    paramObj.insert("item", QJsonValue(fileObj));
    paramObj.insert("playlistid", QJsonValue(playlistId));

    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::clearPlaylist(const int playlistId)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Clear")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    paramObj.insert("playlistid", QJsonValue(playlistId));
    requestJson.insert("params", QJsonValue(paramObj));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::removeItemAtPositionFromPlaylist(const int position, const int playlistId)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.Remove")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    QJsonObject paramObj;
    paramObj.insert("playlistid", QJsonValue(playlistId));
    paramObj.insert("position", QJsonValue(position));
    requestJson.insert("params", QJsonValue(paramObj));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, EDITED_PLAYLIST));
}

void PlayerManager::reloadPlaylists()
{
    this->playlistsModels->clear();
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.GetPlaylists")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYLISTS), QPointer<QObject>(this->playlistsModels));
}

void PlayerManager::getPlaylistItems(PlaylistModelItem *playlist)
{
    playlist->submodel()->clear();
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.GetItems")));
    requestJson.insert("id", QJsonValue(QString("playlist_items")));

    QJsonObject paramObj;
    QJsonArray   properties;

    properties.prepend(QString("title"));
    properties.prepend(QString("file"));
    properties.prepend(QString("thumbnail"));
    properties.prepend(QString("rating"));
    properties.prepend(QString("runtime"));
    paramObj.insert("playlistid", QJsonValue(playlist->id()));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYLIST_ITEMS), QPointer<QObject>(playlist->submodel()));
}

Models::ListModel *PlayerManager::getPlaylistsModel() const
{
    return this->playlistsModels;
}

void PlayerManager::pause_resumeCurrentPlayer()
{
    if (this->currentActivePlayer == -1)
    {
        this->playerActionQueue.append(&PlayerManager::pause_resumeCurrentPlayer);
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.PlayPause")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    requestJson.insert("id", QJsonValue(1));
    requestJson.insert("params", QJsonValue(paramObj));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::playNext()
{
    if (this->currentActivePlayer == -1)
    {
        this->playerActionQueue.append(&PlayerManager::playNext);
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GoTo")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("to", QJsonValue(QString("next")));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::playPrevious()
{
    if (this->currentActivePlayer == -1)
    {
        this->playerActionQueue.append(&PlayerManager::playPrevious);
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GoTo")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("to", QJsonValue(QString("previous")));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::stopCurrentPlayer()
{
    if (this->currentActivePlayer == -1)
    {
        this->playerActionQueue.append(&PlayerManager::stopCurrentPlayer);
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Stop")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
    this->getActivesPlayers();
    this->reloadPlaylists();
}

void PlayerManager::seekCurrentPlayer(int advance)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Seek")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("value", QJsonValue(advance));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    qDebug() << QJsonDocument(requestJson).toJson();

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::smallForward()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Seek")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("value", QJsonValue(QString("smallforward")));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    qDebug() << QJsonDocument(requestJson).toJson();

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::smallBackward()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Seek")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("value", QJsonValue(QString("smallbackward")));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    qDebug() << QJsonDocument(requestJson).toJson();

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::bigForward()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Seek")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("value", QJsonValue(QString("bigforward")));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    qDebug() << QJsonDocument(requestJson).toJson();

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::bigBackward()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Seek")));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("value", QJsonValue(QString("bigbackward")));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    qDebug() << QJsonDocument(requestJson).toJson();

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::getCurrentlyPlayedItem()
{
    if (this->currentActivePlayer == -1)
    {
        this->playerActionQueue.append(&PlayerManager::getCurrentlyPlayedItem);
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GetItem")));

    QJsonObject paramObj;
    QJsonArray properties;

    properties.prepend(QJsonValue(QString("title")));
    properties.prepend(QJsonValue(QString("artist")));
    properties.prepend(QJsonValue(QString("thumbnail")));
    properties.prepend(QJsonValue(QString("runtime")));
    properties.prepend(QJsonValue(QString("duration")));
    properties.prepend(QJsonValue(QString("endtime")));
    properties.prepend(QJsonValue(QString("year")));
    properties.prepend(QJsonValue(QString("genre")));
    properties.prepend(QJsonValue(QString("file")));
    properties.prepend(QJsonValue(QString("rating")));
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYED_ITEM));
}

void PlayerManager::getCurrentPlayerState()
{
    if (this->currentActivePlayer == -1)
    {
        this->playerActionQueue.append(&PlayerManager::getCurrentPlayerState);
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GetProperties")));

    QJsonObject paramObj;
    QJsonArray properties;
    properties.prepend(QJsonValue(QString("percentage")));
    properties.prepend(QJsonValue(QString("speed")));
    paramObj.insert("playerid", QJsonValue(this->currentActivePlayer));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYER_STATE));
}

bool PlayerManager::getIsPlaying() const
{
    return this->isPlayging;
}

double PlayerManager::getPlayerAdvance() const
{
    return this->playerAdvance;
}

int PlayerManager::getMajorIDRequestHandled() const
{
    return MAJOR_ID_REQUEST_PLAYER;
}

void PlayerManager::receiveResultFromHttpRequest(QNetworkReply *reply, int id,  QPointer<QObject> data)
{
    (this->*this->webCallBacks[id])(reply, data);
}

void PlayerManager::playPlaylist(int playlistId, int position)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.Open")));

    QJsonObject paramObj;
    QJsonObject fileObj;

    qDebug() << "playlistId " << playlistId << " pos " << position;

    fileObj.insert("position", QJsonValue(position));
    fileObj.insert("playlistid", QJsonValue(playlistId));
    paramObj.insert("item", QJsonValue(fileObj));
    requestJson.insert("params", QJsonValue(paramObj));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, PLAY_FILE));
}

Models::ListModel* PlayerManager::getCurrentlyPlayedItemModel() const
{
    return this->currentlyPlayerItems;
}

PlayableItemModel *PlayerManager::playableItemModelFromType(QString type)
{
    if (type.compare("movie") == 0)
        return new MovieModel();
    else if (type.compare("song") == 0)
        return new SongModel();
    else if (type.compare("episode") == 0)
        return new TVShowEpisodeModel();
    else
        return NULL;
}

void PlayerManager::genericCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (reply != NULL)
    {
        qDebug() << "Reply -> " << reply->readAll();
    }
}

void PlayerManager::getActivesPlayersCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (reply != NULL)
    {
        QJsonDocument jsonRep = QJsonDocument::fromJson(reply->readAll());
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject() &&
             jsonRep.object().value("result").isArray() &&
             jsonRep.object().value("result").toArray().first().isObject())
        {
            if (jsonRep.object().value("result").toArray().size() > 0)
            {
                this->currentActivePlayer = jsonRep.object().value("result").toArray().first().toObject().value("playerid").toDouble();
                while (!this->playerActionQueue.empty())
                    (this->*this->playerActionQueue.takeFirst())();
                this->getCurrentlyPlayedItem();
            }
            this->playerActionQueue.clear();
        }
    }
}

void PlayerManager::getCurrentlyPlayedItemCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (reply != NULL)
    {
        QJsonDocument jsonRep = QJsonDocument::fromJson(reply->readAll());
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject() &&
             jsonRep.object().value("result").isObject())
        {
            this->currentlyPlayerItems->clear();
            QJsonObject item = jsonRep.object().value("result").toObject().value("item").toObject();
            PlayableItemModel *playableItem = this->playableItemModelFromType(item.value("type").toString());
            if (playableItem != NULL)
            {
                playableItem->setFile(item.value("file").toString());
                playableItem->setTitle(item.value("title").toString());
                playableItem->setRating(item.value("rating").toDouble());
                playableItem->setThumbnail(item.value("thumbnail").toString());
                playableItem->setRuntime(qMax(item.value("duration").toDouble(), item.value("runtime").toDouble()));
                this->currentlyPlayerItems->appendRow(playableItem);
            }
        }
    }
}

void PlayerManager::getCurrentPlayerStateCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (reply != NULL)
    {
        QJsonDocument jsonRep = QJsonDocument::fromJson(reply->readAll());
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject())
        {
            QJsonObject resultObj = jsonRep.object().value("result").toObject();
            bool oldPlaying = this->isPlayging;
            this->isPlayging = (resultObj.value("speed").toDouble() == 0) ? false : true;
            if (oldPlaying != this->isPlayging)
                emit playingChanged();
            if (this->playerAdvance - (resultObj.value("percentage").toDouble() / 100) != 0)
            {
                this->playerAdvance = resultObj.value("percentage").toDouble() / 100;
                emit playerAdvanceChanged();
            }
        }
    }
}

void PlayerManager::getPlaylistsCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonRep = QJsonDocument::fromJson(reply->readAll());
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject())
        {
            QJsonArray resultObj = jsonRep.object().value("result").toArray();
            foreach (QJsonValue playlistValue, resultObj)
            {
                QJsonObject playlistObj = playlistValue.toObject();
                if (!playlistObj.isEmpty())
                {
                    PlaylistModelItem *playlistItem = new PlaylistModelItem(playlistObj.value("playlistid").toDouble(),
                                                                            playlistObj.value("type").toString(),
                                                                            NULL);
                    this->getPlaylistItems(playlistItem);
                    reinterpret_cast<Models::ListModel *>(data.data())->appendRow(playlistItem);
                }
            }
        }
    }
}

void PlayerManager::getPlaylistItemsCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    if (reply != NULL && !data.isNull())
    {
        QJsonDocument jsonRep = QJsonDocument::fromJson(reply->readAll());
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject())
        {
            QJsonObject resultObj = jsonRep.object().value("result").toObject();
            QJsonArray itemsArray = resultObj.value("items").toArray();
            foreach (QJsonValue itemElem, itemsArray)
            {
                QJsonObject item = itemElem.toObject();
                PlayableItemModel *playableItem = this->playableItemModelFromType(item.value("type").toString());
                if (playableItem != NULL)
                {
                    playableItem->setFile(item.value("file").toString());
                    playableItem->setTitle(item.value("title").toString());
                    playableItem->setRating(item.value("rating").toDouble());
                    playableItem->setThumbnail(item.value("thumbnail").toString());
                    playableItem->setRuntime(item.value("runtime").toDouble());
                    reinterpret_cast<Models::ListModel *>(data.data())->appendRow(playableItem);
                }
            }
        }
    }
}

void PlayerManager::playlistEditedCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    Q_UNUSED(data);
    if (reply != NULL)
        qDebug() << reply->readAll();
    this->reloadPlaylists();
}

void PlayerManager::playFileCallBack(QNetworkReply *reply, QPointer<QObject> data)
{
    Q_UNUSED(data);
    if (reply != NULL)
        qDebug() << reply->readAll();
    this->getActivesPlayers();
    this->reloadPlaylists();
}


int PlayerManager::getAudioPlaylistId()
{
    foreach (Models::ListItem *item, this->playlistsModels->toList())
    {
        if (item->data(PlaylistModelItem::playlistTypeString).toString().compare("audio") == 0)
            return item->id();
    }
    return -1;
}

int PlayerManager::getVideoPlaylistId()
{
    foreach (Models::ListItem *item, this->playlistsModels->toList())
    {
        if (item->data(PlaylistModelItem::playlistTypeString).toString().compare("video") == 0)
            return item->id();
    }
    return -1;
}
