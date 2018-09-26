#import "Directions.h"

@implementation Directions

- (void)navigateTo:(CDVInvokedUrlCommand*)command
{

    NSString* destinationAddress = [[[command arguments] objectAtIndex:0] valueForKey:@"destinationAddress"];
    NSString* originAddress = [[[command arguments] objectAtIndex:0] valueForKey:@"originAddress"];
    NSString* lat = [[[command arguments] objectAtIndex:0] valueForKey:@"latitude"];
    NSString* lng = [[[command arguments] objectAtIndex:0] valueForKey:@"longitude"];
    NSNumber* showSource = [[[command arguments] objectAtIndex:0] valueForKey:@"showSource"];
    NSString* currentLoc = @"";
    NSString* directionsMode = [[[command arguments] objectAtIndex:0] valueForKey:@"directionsMode"]; //google-only
    NSString* transportType = @""; //apple-only
    
    if ([directionsMode isEqualToString: @"driving"]) { transportType = @"d"; }
    if ([directionsMode isEqualToString: @"walking"]) { transportType = @"w"; }
    if ([directionsMode isEqualToString: @"transit"]) { transportType = @"r"; }
    if ([directionsMode isEqualToString: @"bicycling"]) { transportType = @"d"; } // not supported by apple

    NSString* url;
    

    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]];

    if (destinationAddress != nil) {
        destinationAddress = [destinationAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    
    if (originAddress != nil) {
        originAddress = [originAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    else {
        originAddress = @"";
    }

    if (canHandle) {
        // Google maps installed
        if (destinationAddress != nil) {
            if ([showSource isEqual: @(YES)]) {
                url = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&directionsmode=%@", originAddress, destinationAddress, directionsMode];
            }
            else {
                url = [NSString stringWithFormat:@"comgooglemaps://?q=%@", destinationAddress];
            }
        } else {
            if ([showSource isEqual: @(YES)]) {
                url = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@,%@&directionsmode=%@", originAddress, lat, lng, directionsMode];
            }
            else {
                url = [NSString stringWithFormat:@"comgooglemaps://?q=%@,%@", lat, lng];
            }
        }
    } else {
        currentLoc = @"current%20location";
        // Use Apple maps
        if (destinationAddress != nil) {
            if ([showSource isEqual: @(YES)]) {
                url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@&dirflg=%@", originAddress, destinationAddress, transportType];
            }
            else {
                url = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@", destinationAddress];
            }
        } else {
            if ([showSource isEqual: @(YES)]) {
                url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@,%@&dirflg=%@", originAddress, lat, lng, transportType];
            }
            else {
                url = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@,%@", lat, lng];
            }
        }
    }

    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:url];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
