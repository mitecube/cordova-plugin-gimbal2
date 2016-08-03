//
//  Gimbal2.h
//  cordova-plugin-gimbal2
//
//  Extended by Mitecube on 7/26/16.
//  Created by Denny Tsai on 4/21/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <Gimbal/Gimbal.h>

@interface Gimbal2 : CDVPlugin <GMBLBeaconManagerDelegate, GMBLCommunicationManagerDelegate, GMBLPlaceManagerDelegate>

@property (nonatomic, strong) GMBLBeaconManager *beaconManager;
@property (nonatomic, strong) GMBLCommunicationManager *communicationManager;
@property (nonatomic, strong) GMBLPlaceManager *placeManager;

- (void)initialize:(CDVInvokedUrlCommand *)command;

- (void)startBeaconManager:(CDVInvokedUrlCommand *)command;
- (void)stopBeaconManager:(CDVInvokedUrlCommand *)command;

@end
