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

PlayerManager::PlayerManager(QObject *parent) : QObject(parent),
    playerModels(new Models::SubListedListModel(new PlayerModelItem(NULL))),
    playlistsModels(new Models::SubListedListModel(new PlaylistModelItem(NULL)))
{
    this->webCallBacks[GENERIC_CALLBACK] = &PlayerManager::genericCallBack;
    this->webCallBacks[GET_ACTIVE_PLAYERS] = &PlayerManager::getActivesPlayersCallBack;
    this->webCallBacks[GET_PLAYED_ITEM] = &PlayerManager::getCurrentlyPlayedItemCallBack;
    this->webCallBacks[GET_PLAYER_STATE] = &PlayerManager::getCurrentPlayerStateCallBack;
    this->webCallBacks[GET_PLAYLISTS] = &PlayerManager::getPlaylistsCallBack;
    this->webCallBacks[GET_PLAYLIST_ITEMS] = &PlayerManager::getPlaylistItemsCallBack;
    this->webCallBacks[EDITED_PLAYLIST] = &PlayerManager::playlistEditedCallBack;
    this->webCallBacks[PLAY_FILE] = &PlayerManager::playFileCallBack;
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

    fileObj.insert("episodeid", QJsonValue(episodeId));
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
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.GetPlaylists")));
    requestJson.insert("id", QJsonValue(QString("playlists")));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYLISTS), QPointer<QObject>(this->playlistsModels));
}

void PlayerManager::getPlaylistItems(PlaylistModelItem *playlist)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Playlist.GetItems")));
    requestJson.insert("id", QJsonValue(QString("playlist_items")));

    QJsonObject paramObj;
    QJsonArray   properties;

    QHash<int, QByteArray> fields = playlist->submodel()->getPrototype()->roleNames();
    fields.remove(PlayableItemModel::streamingFile);
    fields.remove(PlayableItemModel::itemId);
    fields.remove(PlayableItemModel::fanartUrl);
    fields.remove(PlayableItemModel::thumbnailUrl);
    fields.remove(SongModel::songId);
    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));

    paramObj.insert("playlistid", QJsonValue(playlist->id()));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYLIST_ITEMS), QPointer<QObject>(playlist->submodel()));
}

Models::ListModel *PlayerManager::getPlaylistsModel() const
{
    return this->playlistsModels;
}

Models::ListModel *PlayerManager::getPlayersModel() const
{
    return this->playerModels;
}

void PlayerManager::performPlayerAction(const QString& action,
                                        const QString &argName,
                                        const QVariant& values)
{
    if (this->playerModels->rowCount() <= 0)
    {
        this->getActivesPlayers();
        return ;
    }
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(action));

    QJsonObject paramObj;
    paramObj.insert("playerid", QJsonValue(this->playerModels->toList().at(0)->id()));
    if (!argName.isEmpty() && values.isValid())
        paramObj.insert(argName, QJsonValue::fromVariant(values));
    requestJson.insert("id", QJsonValue(1));
    requestJson.insert("params", QJsonValue(paramObj));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GENERIC_CALLBACK));
}

void PlayerManager::getCurrentlyPlayedItem(PlayerModelItem * player)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GetItem")));

    QJsonObject paramObj;
    QJsonArray properties;

    qDebug() << player->submodel()->getPrototype()->roleTypesFromName().keys();

    QHash<int, QByteArray> fields = player->submodel()->getPrototype()->roleNames();
    fields.remove(PlayableItemModel::streamingFile);
    fields.remove(PlayableItemModel::itemId);
    fields.remove(PlayableItemModel::fanartUrl);
    fields.remove(PlayableItemModel::thumbnailUrl);
    fields.remove(SongModel::songId);
    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));

    paramObj.insert("playerid", QJsonValue(player->id()));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson,
                               REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYED_ITEM),
                               QPointer<QObject>(player));
}

void PlayerManager::getActivesPlayers()
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GetActivePlayers")));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson, REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_ACTIVE_PLAYERS));
}

void PlayerManager::getPlayerState(PlayerModelItem * player)
{
    QJsonObject requestJson;
    requestJson.insert("jsonrpc", QJsonValue(QString("2.0")));
    requestJson.insert("method", QJsonValue(QString("Player.GetProperties")));

    QJsonObject paramObj;
    QJsonArray properties;

    QHash<int, QByteArray> fields = player->roleNames();
    fields.remove(PlayerModelItem::playerid);
    fields.remove(PlayerModelItem::playerItemsModel);
    fields.remove(PlayerModelItem::playerType);
    foreach (const QByteArray field, fields)
        properties.prepend(QJsonValue(QString(field)));

    paramObj.insert("playerid", QJsonValue(player->id()));
    paramObj.insert("properties", QJsonValue(properties));
    requestJson.insert("params", QJsonValue(paramObj));
    requestJson.insert("id", QJsonValue(1));

    emit performJsonRPCRequest(requestJson,
                               REQUEST_ID_BUILDER(MAJOR_ID_REQUEST_PLAYER, GET_PLAYER_STATE),
                               QPointer<QObject>(player));
}

void PlayerManager::refreshPlayers()
{
    foreach (Models::ListItem *player, this->playerModels->toList())
        this->getPlayerState(reinterpret_cast<PlayerModelItem *>(player));
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
        qDebug() << jsonRep.toJson();
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject() &&
             jsonRep.object().value("result").isArray() &&
             jsonRep.object().value("result").toArray().first().isObject())
        {
            QJsonArray resultsArray = jsonRep.object().value("result").toArray();
            if (resultsArray.size() > 0)
            {
                QList<Models::ListItem *> oldItems = this->playerModels->toList();
                QList<Models::ListItem *> updatedItems;
                foreach (const QJsonValue& value, resultsArray)
                {
                    PlayerModelItem *player = new PlayerModelItem();
                    Models::JSONListItemBinder::fromQJsonValue(value, player);
                    PlayerModelItem *oldItem;
                    if ((oldItem = reinterpret_cast<PlayerModelItem *>
                         (this->playerModels->find(player->id()))) != NULL)
                    {
                        *oldItem = *player;
                        delete player;
                        updatedItems << oldItem;
                        this->getCurrentlyPlayedItem(oldItem);
                        oldItem->triggerItemUpdate();
                    }
                    else
                    {
                        this->playerModels->appendRow(player);
                        this->getCurrentlyPlayedItem(player);
                    }
                }
                for (int i = oldItems.count(); i > 0; i--)
                {
                    bool found = false;
                    Models::ListItem *item = oldItems.at(i - 1);
                    for (int j = updatedItems.count() - 1; j >= 0; j--)
                    {
                        if (updatedItems.at(j)->id() == item->id())
                        {
                            updatedItems.removeAt(j);
                            found = true;
                            break;
                        }
                    }
                    if (!found)
                        this->playerModels->removeRow(this->playerModels->getRowFromItem(item));
                }
            }
        }
    }
}

void PlayerManager::getCurrentlyPlayedItemCallBack(QNetworkReply *reply,  QPointer<QObject> data)
{
    Q_UNUSED(data)
    if (reply != NULL)
    {
        QJsonDocument jsonRep = QJsonDocument::fromJson(reply->readAll());
        qDebug() << jsonRep.toJson();
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject() &&
             jsonRep.object().value("result").isObject())
        {
            PlayerModelItem *player = reinterpret_cast<PlayerModelItem *>(data.data());
            PlayableItemModel *newModel = reinterpret_cast<PlayableItemModel *>(player->submodel()->getPrototype()->getNewItemInstance());
            PlayableItemModel *oldItem;

            QJsonObject item = jsonRep.object().value("result").toObject().value("item").toObject();
            Models::JSONListItemBinder::fromQJsonValue(item, newModel);

            if ((oldItem = reinterpret_cast<PlayableItemModel *>(player->submodel()->find(newModel->id()))) != NULL)
            {
                *oldItem = *newModel;
                delete newModel;
            }
            else
            {
                player->submodel()->clear();
                player->submodel()->appendRow(newModel);
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
        qDebug() << jsonRep.toJson();
        if  (!jsonRep.isNull() &&
             !jsonRep.isEmpty() &&
             jsonRep.isObject())
        {
            QJsonObject resultObj = jsonRep.object().value("result").toObject();
            PlayerModelItem *player = reinterpret_cast<PlayerModelItem *>(data.data());
            Models::JSONListItemBinder::fromQJsonValue(resultObj, player);
            player->triggerItemUpdate();
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
            Models::ListModel *model = reinterpret_cast<Models::ListModel *>(data.data());
            foreach (const QJsonValue &playlistValue, resultObj)
            {
                QJsonObject playlistObj = playlistValue.toObject();
                if (!playlistObj.isEmpty())
                {
                    PlaylistModelItem *playlistItem = new PlaylistModelItem();
                    Models::JSONListItemBinder::fromQJsonValue(playlistObj, playlistItem);
                    if (playlistItem->id() != -1)
                    {
                        Models::ListItem  *oldItem;
                        if ((oldItem = model->find(playlistItem->id())) == NULL)
                        {
                            model->appendRow(playlistItem);
                            oldItem = playlistItem;
                            oldItem->triggerItemUpdate();
                        }
                        else
                            delete playlistItem;
                        this->getPlaylistItems(reinterpret_cast<PlaylistModelItem *>(oldItem));
                    }
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
            Models::ListModel *model = reinterpret_cast<Models::ListModel *>(data.data());
            QList<Models::ListItem *> updatedItems;
            QList<Models::ListItem *> oldItems = model->toList();
            uint count = 0;
            foreach (const QJsonValue& itemElem, itemsArray)
            {
                QJsonObject item = itemElem.toObject();
                Models::ListItem *playableItem = model->getPrototype()->getNewItemInstance();
                Models::JSONListItemBinder::fromQJsonValue(item, playableItem);
                if (playableItem->id() != -1)
                {
                    // We can have several times the same song in a playlist
                    // So we check if we find the same song at the same position
                    Models::ListItem* oldItem = oldItems.value(count);
                    if (oldItem != NULL && oldItem->id() == playableItem->id())
                    {
                        *oldItem = *playableItem;
                        delete playableItem;
                        updatedItems << oldItem;
                        oldItem->triggerItemUpdate();
                    }
                    else
                        model->appendRow(playableItem);
                }
                count++;
            }
            for (int i = oldItems.count(); i > 0; i--)
            {
                bool found = false;
                Models::ListItem *item = oldItems.at(i - 1);
                for (int j = updatedItems.count() - 1; j >= 0; j--)
                {
                    if (updatedItems.at(j)->id() == item->id())
                    {
                        updatedItems.removeAt(j);
                        found = true;
                        break;
                    }
                }
                if (!found)
                    model->removeRow(model->getRowFromItem(item));
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
