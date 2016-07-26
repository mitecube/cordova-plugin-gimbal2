//
//  Gimbal2.h
//  cordova-plugin-gimbal2
//
//  Extended by Mitecube on 7/26/16.
//  Created by Denny Tsai on 4/21/15.
//
//

#import "Gimbal2.h"
#import "Foundation/NSString.h"

@implementation Gimbal2 {
    NSString *statusCallbackId;
    NSDateFormatter *dateFormatter;
}

- (void)pluginInitialize {
    [super pluginInitialize];

    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

    self.beaconManager = [[GMBLBeaconManager alloc] init];
    self.beaconManager.delegate = self;

    self.communicationManager = [[GMBLCommunicationManager alloc] init];
    self.communicationManager.delegate = self;
}

- (void)initialize:(CDVInvokedUrlCommand *)command {
    NSString *apiKey = command.arguments[0];
    statusCallbackId = command.callbackId;

    [Gimbal setAPIKey:apiKey options:nil];

    // Patch fabio 20/07/2016
    [GMBLCommunicationManager startReceivingCommunications];

    // Register the supported interaction types.
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    // Register for remote notifications.
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    [Gimbal start];
    // Patch fabio 20/07/2016
}

- (void)startBeaconManager:(CDVInvokedUrlCommand *)command {
    [self.beaconManager startListening];
}

- (void)stopBeaconManager:(CDVInvokedUrlCommand *)command {
    [self.beaconManager stopListening];
}

- (void)beaconManager:(GMBLBeaconManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting {
    GMBLBeacon *beacon = sighting.beacon;
    NSDictionary *returnData = @{
        @"event": @"onBeaconSighting",
        @"RSSI": [NSNumber numberWithInteger:sighting.RSSI],
        @"datetime": [dateFormatter stringFromDate:sighting.date],
        @"beaconName": (beacon.name != nil) ? beacon.name : [NSNull null],
        @"beaconIdentifier": (beacon.identifier != nil) ? beacon.identifier : [NSNull null],
        @"beaconBatteryLevel": [NSNumber numberWithFloat:beacon.batteryLevel],
        @"beaconIconUrl": (beacon.iconURL != nil) ? beacon.iconURL : [NSNull null],
        @"beaconTemperature": [NSNumber numberWithInteger:beacon.temperature],
    };

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:returnData];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:statusCallbackId];
}

- (NSArray *)communicationManager:(GMBLCommunicationManager *)manager presentLocalNotificationsForCommunications:(NSArray *)communications forVisit:(GMBLVisit *)visit
{
    // This will be invoked when a user has a communication for the place that was entered or exited.
    // Return an array of communications you would like presented as local notifications.
    // If you implement this method to filter communications, you MUST handle frequency limiting and delay yourself.

    for (GMBLCommunication *communication in communications) {
        NSDictionary *returnData = @{
            @"event": @"onCommunicationPresentedVisit",
            @"title": communication.title,
            @"description": communication.descriptionText,
        };

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:returnData];
        pluginResult.keepCallback = [NSNumber numberWithBool:YES];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:statusCallbackId];
    }

    return communications;

}

- (void) setDeviceToken:(CDVInvokedUrlCommand *)command {
    NSString *hexstr = command.arguments[0];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSString *inputStr = [hexstr uppercaseString];

        NSString *hexChars = @"0123456789ABCDEF";

        Byte b1,b2;
        b1 = 255;
        b2 = 255;
        for (int i=0; i<hexstr.length; i++) {
            NSString *subStr = [inputStr substringWithRange:NSMakeRange(i, 1)];
            NSRange loc = [hexChars rangeOfString:subStr];

            if (loc.location == NSNotFound) continue;

            if (255 == b1) {
                b1 = (Byte)loc.location;
            }else {
                b2 = (Byte)loc.location;

                //Appending the Byte to NSData
                Byte *bytes = malloc(sizeof(Byte) *1);
                bytes[0] = ((b1<<4) & 0xf0) | (b2 & 0x0f);
                [data appendBytes:bytes length:1];

                b1 = b2 = 255;
            }
        }

    [Gimbal setPushDeviceToken:data];
}


@end
