#ifndef COREAPPLICATION_H
#define COREAPPLICATION_H

#include <QObject>
#include <QSettings>
#include <QtQml>
#include "AudioLibrary.h"
#include "VideoLibrary.h"
#include "RemoteManager.h"
#include "PlayerManager.h"
#include "databaseThread.h"
#include "WebServiceManager.h"

#define DATABASE_NAME "smooth_remote.sql"

class AudioLibrary;
class VideoLibrary;
class RemoteManager;
class PlayerManager;


class CoreApplication : public QObject,
        public WebServiceUserInterface,
        public DatabaseServiceUserInterface
{
    Q_OBJECT
    Q_INTERFACES(WebServiceUserInterface)
    Q_INTERFACES(DatabaseServiceUserInterface)
    Q_PROPERTY(int xbmcServerPort WRITE setXbmcServerPort READ getXbmcServerPort NOTIFY xbmcServerPortChanged)
    Q_PROPERTY(QUrl xbmcServerUrl WRITE setXbmcServerUrl READ getXbmcServerUrl NOTIFY xbmcServerUrlChanged)
    Q_PROPERTY(QString xbmcServerUserName WRITE setXbmcServerUserName READ getXbmcServerUserName NOTIFY xbmcServerUserNameChanged)
    Q_PROPERTY(QString xbmcServerPassword WRITE setXbmcServerPassword READ getXbmcServerPassword NOTIFY xbmcServerPasswordChanged)
    Q_PROPERTY(QObject* tvShowModel READ getTvShowModel CONSTANT)
    Q_PROPERTY(QObject* movieModel READ getMovieModel CONSTANT)
    Q_PROPERTY(QObject* audioArtistsModel READ getAudioArtistsModel CONSTANT)
    Q_PROPERTY(QObject* playlistsModel READ getPlaylistsModel CONSTANT)

public:
    enum ActionEnums
    {
        Up = 0,
        Down = 1,
        Left = 2,
        Right = 3,
        Validate = 4,
        Back = 5,
        Home = 6,
        Play = 7,
        Stop = 8,
        Next = 9,
        Previous = 10,
        Seek = 11,
        Forward = 12,
        Backward = 13,
        PlayFile = 14,
        ArtistToPlaylist = 15,
        AlbumToPlaylist = 16,
        EpisodeToPlaylist = 17,
        FileToPlaylist = 18,
        PlayPlaylist = 19,
        RemovePlaylist = 20,
        ClearPlaylist = 21,
        RemoveItemInPlaylist = 22
    };


    ~CoreApplication();
    static CoreApplication* getInstance();

private:
    static CoreApplication *instance;
    explicit CoreApplication(QObject *parent = 0);

    AudioLibrary *audioLibrary;
    VideoLibrary *videoLibrary;
    RemoteManager *remoteManager;
    PlayerManager *playerManager;

    DatabaseThread*     dbServiceManager;
    WebServiceManager*  webServiceManager;

    int         xbmcServerPort;
    QUrl        xbmcServerUrl;
    QString     xbmcServerUserName;
    QString     xbmcServerPassword;
    QUrl        xbmcFullServerUrl;


    QHash<int, IDBDispatcher *>         databaseResultDispatcher;
    QHash<int, IWebRequestDispatcher*>  networkRequestResultDispatch;

    void        readSettings();
    void        saveSettings();

public:

    // XBMC CONF

    void                        setXbmcServerPort(int port);
    void                        setXbmcServerUrl(const QUrl &url);
    void                        setXbmcServerUserName(const QString &username);
    void                        setXbmcServerPassword(const QString &password);

    int                         getXbmcServerPort()  const;
    QUrl                        getXbmcServerUrl()    const;
    QUrl                        getXbmcServerRequestUrl() const;
    QString                     getXbmcServerUserName() const;
    QString                     getXbmcServerPassword()   const;

    // SHOWS
    QObject*                    getTvShowModel() const;
    Q_INVOKABLE void            refreshSeasonsForShow(int showId) const;
    // MOVIES
    QObject*                    getMovieModel() const;
    // MUSIC
    QObject*                    getAudioArtistsModel() const;
    Q_INVOKABLE void            refreshAlbumsForArtist(int artistId) const;
    // REMOTE
    Q_INVOKABLE void            buttonAction(int buttonAction, QVariant value = QVariant());
    // PLAYLISTS
    QObject*                    getPlaylistsModel() const;


    // WebServiceUserInterface interface
    void receiveResultFromHttpRequest(QNetworkReply *reply, int requestId, QPointer<QObject> data);

    // DatabaseServiceUserInterface interface
    void receiveResultFromSQLQuery(QList<QSqlRecord> result, int id, QPointer<QObject> data);

private slots:

    void performJsonRPCRequest(const QJsonObject& request,
                               int requestId,
                               QPointer<QObject> data);
    void performSQLQuery(const QString &query,
                         int requestId,
                         QPointer<QObject> data);

public slots:

signals:
    // WebServiceUserInterface interface
    void executeHttpRequest(const QNetworkRequest &request, WebServiceUserInterface::WebServiceRequestType type, QHttpMultiPart *, QPointer<QObject> sender, int requestId, QPointer<QObject> data);
    // DatabaseServiceUserInterface interface
    void executeSQLQuery(const QString &query, QPointer<QObject> sender, int id, const QString &dbName, QPointer<QObject> data);
    // XBMC CONF
    void xbmcServerUrlChanged();
    void xbmcServerPortChanged();
    void xbmcServerPasswordChanged();
    void xbmcServerUserNameChanged();
};

#endif // COREAPPLICATION_H
