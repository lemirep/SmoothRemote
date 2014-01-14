#include <QtGui/QGuiApplication>
#include "ViewManagement.h"
#include "CoreApplication.h"
#include <QDebug>
#include <QtQml>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    QCoreApplication::setOrganizationName("Paul Lemire");
    QCoreApplication::setApplicationName("Smooth Remote");

    QScopedPointer<CoreApplication> coreApplication(CoreApplication::getInstance());

    ViewManagement *viewManager = ViewManagement::getInstance();
    QObject::connect(viewManager, SIGNAL(destroyed()), app.data(), SLOT(quit()));


    viewManager->setSource(QUrl("qrc:/qml/main.qml"));
    viewManager->getContext()->setContextProperty("core", coreApplication.data());
    viewManager->showFullScreen();


    return app->exec();
}
