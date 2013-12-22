
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
    qml/TextInputComponent.qml \
    qml/DynamicGridView.qml \
    qml/TVShowDetailScreen.qml \
    qml/CoverImage.qml

HEADERS += \
    qml/MainView.h

ANDROID_TARGET_ARCH = armeabi-v7a

qnx {
    PACKAGE_ARGS = \
        $${PWD}/bar-descriptor.xml $$TARGET \
        -e $$[QT_INSTALL_LIBS]/libQt5Core.so.5 lib/libQt5Core.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Gui.so.5 lib/libQt5Gui.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5OpenGL.so.5 lib/libQt5OpenGL.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Network.so.5 lib/libQt5Network.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Quick.so.5 lib/libQt5Quick.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Qml.so.5 lib/libQt5Qml.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5Sql.so.5 lib/libQt5Sql.so.5 \
        -e $$[QT_INSTALL_LIBS]/libQt5V8.so.5 lib/libQt5V8.so.5 \
        -e $$[QT_INSTALL_PLUGINS]/platforms/libqqnx.so plugins/platforms/libqqnx.so \
        -e $$[QT_INSTALL_PLUGINS]/imageformats/libqjpeg.so plugins/imageformats/libqjpeg.so \
        -e $$[QT_INSTALL_QML]/ qml/

    package.target = $${TARGET}.bar
    package.depends = $$TARGET
    package.commands = blackberry-nativepackager \
        -package $${TARGET}.bar \
        -devMode -debugToken $$(DEBUG_TOKEN) \
        $${PACKAGE_ARGS}

    QMAKE_EXTRA_TARGETS += package

    OTHER_FILES += bar-descriptor.xml
}
