
HEADERS += CoreApplication.h

SOURCES += main.cpp \
           CoreApplication.cpp

RESOURCES += \
    resources.qrc

INCLUDEPATH += $$PWD

include (./Global/Global.pri)
include (./Models/Models.pri)
include (./Audio/Audio.pri)
include (./Video/Video.pri)
include (./Player/Player.pri)
include (./Remote/Remote.pri)
include (./View/View.pri)
include (./DatabaseManagement/DatabaseManagement.pri)
include (./WebServiceManagement/WebServiceManagement.pri)

OTHER_FILES += \
    qml/main.qml \
    qml/SlideMenu.qml \
    qml/MainView.qml \
    qml/RemoteScreen.qml \
    qml/MovieScreen.qml \
    qml/TVShowScreen.qml \
    qml/TopBanner.qml \
    qml/SettingsScreen.qml \
    qml/AudioScreen.qml \
    qml/TextInputComponent.qml

HEADERS += \
    qml/MainView.h
