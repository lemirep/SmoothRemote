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

#ifndef PLAYERMANAGER_H
#define PLAYERMANAGER_H

#include <QObject>
#include <QPointer>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonDocument>
#include <QList>
#include <SubListedListModel.h>
#include "IWebRequestDispatcher.h"
#include "PlayableItemModel.h"
#include "MovieModel.h"
#include "TVShowEpisodeModel.h"
#include "SongModel.h"
#include "PlaylistModelItem.h"

#define MAJOR_ID_REQUEST_PLAYER 2
#define GENERIC_CALLBACK 0
#define GET_ACTIVE_PLAYERS 1
#define GET_PLAYED_ITEM 2
#define GET_PLAYER_STATE 3
#define GET_PLAYLISTS 4
#define GET_PLAYLIST_ITEMS 5
#define EDITED_PLAYLIST 6
#define PLAY_FILE 7

class PlayerManager : public QObject, public IWebRequestDispatcher
{
    Q_OBJECT
public:
    PlayerManager(QObject *parent = 0);

    void                    getActivesPlayers();
    void                    playFile(const QString &file);

    void                    pause_resumeCurrentPlayer();
    void                    playNext();
    void                    playPrevious();
    void                    stopCurrentPlayer();
    void                    seekCurrentPlayer(int advance);
    void                    smallForward();
    void                    smallBackward();
    void                    bigForward();
    void                    bigBackward();
    void                    getCurrentlyPlayedItem();
    void                    getCurrentPlayerState();


    bool                    getIsPlaying() const;
    double                  getPlayerAdvance() const;

    int                     getMajorIDRequestHandled() const;
    void                    receiveResultFromHttpRequest(QNetworkReply *reply, int id, QPointer<QObject> data);

    void                    playPlaylist(int playlistId, int position = 0);
    void                    addFileToPlayList(const QString &file, const int playlistId);
    void                    addArtistToPlaylist(const int artistId);
    void                    addAlbumToPlaylist(const int albumId);
    void                    addSongToPlaylist(const int songId);
    void                    addMovieToPlaylist(const int movieId);
    void                    addEpisodeToPlaylist(const int episodeId);
    void                    clearPlaylist(const int playlistId);
    void                    removeItemAtPositionFromPlaylist(const int position, const int playlistId);
    void                    reloadPlaylists();
    void                    addPlaylist();
    void                    removePlaylist();

    int                     getAudioPlaylistId();
    int                     getVideoPlaylistId();

    Models::ListModel*      getPlaylistsModel() const;
    Models::ListModel*      getCurrentlyPlayedItemModel() const;


private:
    QHash<int, void (PlayerManager::*)(QNetworkReply *reply, QPointer<QObject> data)>   webCallBacks;
    QList<void (PlayerManager::*)()>    playerActionQueue;
    Models::ListModel                   *currentlyPlayerItems;
    Models::SubListedListModel          *playlistsModels;

    int                                 currentActivePlayer;
    bool                                isPlayging;
    double                              playerAdvance;

    void                    getPlaylistItems(PlaylistModelItem *playlist);

    void                    genericCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                    getActivesPlayersCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                    getCurrentlyPlayedItemCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                    getCurrentPlayerStateCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                    getPlaylistsCallBack(QNetworkReply *reply,QPointer<QObject> data);
    void                    getPlaylistItemsCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                    playlistEditedCallBack(QNetworkReply *reply, QPointer<QObject> data);
    void                    playFileCallBack(QNetworkReply *reply, QPointer<QObject> );

    PlayableItemModel       *playableItemModelFromType(QString type);

signals:
    void                    performJsonRPCRequest(const QJsonObject &request, int requestId, QPointer<QObject> data=QPointer<QObject>());
    void                    playingChanged();
    void                    playerAdvanceChanged();
};

#endif // PLAYERMANAGER_H
