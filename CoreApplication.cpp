#include "CoreApplication.h"

CoreApplication* CoreApplication::instance = NULL;

CoreApplication::CoreApplication(QObject *parent) :
    QObject(parent),
    audioLibrary(new AudioLibrary()),
    videoLibrary(new VideoLibrary()),
    remoteManager(new RemoteManager()),
    playerManager(new PlayerManager()),
    dbServiceManager(new DatabaseThread()),
    webServiceManager(new WebServiceManager())
{
    // CONNECTION TO SERVICES
    QObject::connect(this, SIGNAL(executeHttpRequest(QNetworkRequest,WebServiceUserInterface::WebServiceRequestType,QHttpMultiPart*,QPointer<QObject>,int,QPointer<QObject>)),
                     this->webServiceManager, SLOT(executeHttpRequest(QNetworkRequest,WebServiceUserInterface::WebServiceRequestType,QHttpMultiPart*,QPointer<QObject>,int,QPointer<QObject>)));
    QObject::connect(this, SIGNAL(executeSQLQuery(QString,QPointer<QObject>,int,QString,QPointer<QObject>)),
                     this->dbServiceManager, SIGNAL(executeSQLQuery(QString,QPointer<QObject>,int,QString,QPointer<QObject>)));

    // LIBRARY CONNECTION TO CORE APP INSTANCE
    QObject::connect(this->audioLibrary, SIGNAL(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)),
                     this, SLOT(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)));
    QObject::connect(this->videoLibrary, SIGNAL(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)),
                     this, SLOT(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)));
    QObject::connect(this->remoteManager, SIGNAL(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)),
                     this, SLOT(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)));
    QObject::connect(this->playerManager, SIGNAL(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)),
                     this, SLOT(performJsonRPCRequest(QJsonObject,int,QPointer<QObject>)));

    this->networkRequestResultDispatch[this->audioLibrary->getMajorIDRequestHandled()] = this->audioLibrary;
    this->networkRequestResultDispatch[this->videoLibrary->getMajorIDRequestHandled()] = this->videoLibrary;
    this->networkRequestResultDispatch[this->remoteManager->getMajorIDRequestHandled()] = this->remoteManager;
    this->networkRequestResultDispatch[this->playerManager->getMajorIDRequestHandled()] = this->playerManager;
    this->databaseResultDispatcher[this->audioLibrary->getMajorDBIDRequest()] = this->audioLibrary;
    this->databaseResultDispatcher[this->videoLibrary->getMajorDBIDRequest()] = this->videoLibrary;

    //    this->databaseResultDispatcher[this->videoLibrary->getMajorDBIDRequest()] = this->videoLibrary;
    //    this->databaseResultDispatcher[this->audioLibrary->getMajorDBIDRequest()] = this->audioLibrary;
    this->readSettings();
//    this->videoLibrary->reloadDataModels(true);
}

void CoreApplication::readSettings()
{
    QSettings settings;
    this->setXbmcServerUrl(settings.value("server/url", "").toUrl());
    this->setXbmcServerPort(settings.value("server/port", 8080).toInt());
    this->setXbmcServerPassword(settings.value("server/password", "").toString());
    this->setXbmcServerUserName(settings.value("server/username", "xbmc").toString());
}

void CoreApplication::saveSettings()
{
    QSettings settings;
    settings.setValue("server/url", this->xbmcServerUrl);
    settings.setValue("server/port", this->xbmcServerPort);
    settings.setValue("server/username", this->xbmcServerUserName);
    settings.setValue("server/password", this->xbmcServerPassword);
    settings.sync();
}

CoreApplication::~CoreApplication()
{
    this->saveSettings();
    delete this->dbServiceManager;
    delete this->webServiceManager;
    delete this->audioLibrary;
    delete this->videoLibrary;
    delete this->remoteManager;
    delete this->playerManager;
    CoreApplication::instance = NULL;
}

CoreApplication *CoreApplication::getInstance()
{
    if (CoreApplication::instance == NULL)
        CoreApplication::instance = new CoreApplication();
    return CoreApplication::instance;
}

void CoreApplication::performJsonRPCRequest(const QJsonObject& request,
                                            int requestId,
                                            QPointer<QObject> data)
{
    qDebug() << "Performing Request" << this->getXbmcServerRequestUrl().toString() + "?request=" + QJsonDocument(request).toJson();
    emit executeHttpRequest(
                QNetworkRequest(QUrl(this->getXbmcServerRequestUrl().toString() + "?request=" + QJsonDocument(request).toJson())),
                WebServiceUserInterface::Get,
                NULL,
                QPointer<QObject>(this),
                requestId,
                data);
}

void CoreApplication::performSQLQuery(const QString &query,
                                      int requestId,
                                      QPointer<QObject> data)
{
    emit executeSQLQuery(query,
                         QPointer<QObject>(this),
                         requestId,
                         DATABASE_NAME,
                         data);
}

void CoreApplication::receiveResultFromHttpRequest(QNetworkReply *reply,
                                                   int requestId,
                                                   QPointer<QObject> data)
{
    qDebug() << "Query Result";
    this->networkRequestResultDispatch[requestId / 10]->receiveResultFromHttpRequest(reply, requestId % 10, data);
    reply->close();
    delete reply;
}

void CoreApplication::receiveResultFromSQLQuery(QList<QSqlRecord> result,
                                                int id,
                                                QPointer<QObject> data)
{
    this->databaseResultDispatcher[id / 10]->receiveResultFromSQLQuery(result, id % 10, data);
}

void CoreApplication::setXbmcServerPort(int port)
{
    if (port != this->xbmcServerPort)
    {
        this->xbmcServerPort = port;
        this->xbmcFullServerUrl.setPort(this->xbmcServerPort);
        emit xbmcServerPortChanged();
    }
}

void CoreApplication::setXbmcServerUrl(const QUrl &url)
{
    if (url != this->xbmcServerUrl)
    {
        this->xbmcServerUrl = url;
        if (this->xbmcServerUrl.scheme().isEmpty())
            this->xbmcServerUrl.setScheme("http://");
        this->xbmcFullServerUrl.setScheme(this->xbmcServerUrl.scheme());
        this->xbmcFullServerUrl.setHost(this->xbmcServerUrl.host());
        PlayableItemModel::xbmcHostUrl = this->xbmcFullServerUrl;
        emit xbmcServerUrlChanged();
    }
}

void CoreApplication::setXbmcServerUserName(const QString &username)
{
    if (username != this->xbmcServerUserName)
    {
        this->xbmcServerUserName = username;
        this->xbmcFullServerUrl.setUserName(this->xbmcServerUserName);
        PlayableItemModel::xbmcHostUrl = this->xbmcFullServerUrl;
        emit xbmcServerUserNameChanged();
    }
}

void CoreApplication::setXbmcServerPassword(const QString &password)
{
    if (password != this->xbmcServerPassword)
    {
        this->xbmcServerPassword = password;
        this->xbmcFullServerUrl.setPassword(this->xbmcServerPassword);
        PlayableItemModel::xbmcHostUrl = this->xbmcFullServerUrl;
        emit xbmcServerPasswordChanged();
    }
}

int CoreApplication::getXbmcServerPort() const
{
    return this->xbmcServerPort;
}

QUrl CoreApplication::getXbmcServerUrl() const
{
    return this->xbmcServerUrl;
}

QUrl CoreApplication::getXbmcServerRequestUrl() const
{
    QUrl url(this->xbmcFullServerUrl);
    url.setPath(xbmcFullServerUrl.path() + "/jsonrpc");
    return url;
}

QString CoreApplication::getXbmcServerUserName() const
{
    return this->xbmcServerUserName;
}

QString CoreApplication::getXbmcServerPassword() const
{
    return this->xbmcServerPassword;
}

QObject *CoreApplication::getTvShowModel() const
{
    return this->videoLibrary->getTVShowsLibraryModel();
}

void CoreApplication::refreshSeasonsForShow(int showId) const
{
    this->videoLibrary->refreshSeasonsForShow(showId);
}

QObject *CoreApplication::getMovieModel() const
{
    return this->videoLibrary->getMoviesLibraryModel();
}

QObject *CoreApplication::getAudioArtistsModel() const
{
    return this->audioLibrary->getArtistsLibraryModel();
}
