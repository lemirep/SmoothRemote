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

#ifndef REMOTEMANAGER_H
#define REMOTEMANAGER_H

#include <QObject>
#include <QPointer>
#include <QJsonObject>
#include <QJsonValue>
#include <IWebRequestDispatcher.h>
#include <QDebug>
#include "Utils.h"

#define MAJOR_ID_REQUEST_REMOTE 3
#define KEY_PRESSED 0


class RemoteManager : public QObject, public IWebRequestDispatcher
{
    Q_OBJECT
public:
    // REMOTE CONTROL ACTIONS
    enum NavigationKeys
    {
        Up = 0,
        Down,
        Left,
        Right,
        Back,
        Select,
        Home
    };
public:
    RemoteManager(QObject *parent = 0);
    ~RemoteManager();

    void            receiveResultFromHttpRequest(QNetworkReply *reply, int id, QPointer<QObject> data);
    int             getMajorIDRequestHandled() const;

    void            moveKey(NavigationKeys key);

    void            rebootSystem();
    void            shutdownSystem();
    void            suspendSystem();
    void            hibernateSystem();



private:
    QHash<NavigationKeys, QString>   webServiceMethods;
    void            moveKeyCallBack(QNetworkReply *reply);
signals:
    void            performJsonRPCRequest(const QJsonObject &request, int requestId, QPointer<QObject> data=QPointer<QObject>());
};

#endif // REMOTEMANAGER_H
