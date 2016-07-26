# Cordova Gimbal v2 Plugin

This plugin is a fork of the original Cordova Gimbal 2 plugin. (https://github.com/happydenn/cordova-plugin-gimbal2)

It adds support for communications coming from Gimbal. 


## Supported Platforms

- iOS 7.1+
- Android 4.4.3, 4.4.4, 5.0+ (5.0+ recommended)

_Support for previous versions is not possible because the lack of Bluetooth LE support in earlier versions of the platforms._


## Supported SDK Features

- Beacon Manager: listen for beacon sightings
- Communication Manager: register to push notification services and trigger events on message received


## Requirements

- Gimbal Manager account
- Gimbal SDK v2 (latest version can be obtained from Gimbal Manager web app)
- Gimbal beacons (can be bought on Gimbal's online store)


## Installation

### Plugin Setup

```text
cordova plugin add https://github.com/mitecube/cordova-plugin-gimbal2
```

### Gimbal SDK Setup

#### iOS

From the downloaded SDK, drag and drop __Gimbal.framework__ from the __Frameworks__ folder to the __Frameworks__ group inside the Xcode project. Be sure to copy the files when asked by Xcode.

Customize (if needed) in the Xcode project's Info.plist the defualt message to properly request for permission to use the location service which is required by Gimbal SDK.

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>Specifies the reason for accessing the user's location information.</string>
```

#### Android

From the downloaded SDK, copy all the jars inside the __libs__ folder to the __libs__ folder located in the Android platform folder.

Next inside the __'platforms/android'__ folder of your project, create a new file named __build-extras.gradle__ (open the file if it already exists) and add the following lines:

```
ext.postBuildExtras = {
    android {
        packagingOptions {
            exclude 'META-INF/notice.txt'
            exclude 'META-INF/license.txt'
        }
    }
}
```

This will get rid of the error while building the Android version.


## Plugin API

### Methods

#### Gimbal2.initialize(apiKey)

Initialize the Gimbal SDK with the API key.

- apiKey: API key (generated from Gimbal Manager web backend)

#### Gimbal2.startBeaconManager()

Start the BeaconManager. BeaconManager is responsible for scanning nearby beacons.

#### Gimbal2.stopBeaconManager()

Stop the BeaconManager.

### Events

Events are fired on the window object. Attach event listeners to handle the events.

#### beaconsighting

Fires when a beacon is scanned by the BeaconManager.

- __RSSI__: Signal strength of the sighting
- __datetime__: Time when the sighting occured
- __beaconName__
- __beaconIdentifier__
- __beaconBatteryLevel__
- __beaconIconUrl__
- __beaconTemperature__
