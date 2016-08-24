#import "Directions.h"

@implementation Directions

- (void)navigateTo:(CDVInvokedUrlCommand*)command
{
    NSString* address = [[[command arguments] objectAtIndex:0] valueForKey:@"address"];
    NSString* lat = [[[command arguments] objectAtIndex:0] valueForKey:@"latitude"];
    NSString* lng = [[[command arguments] objectAtIndex:0] valueForKey:@"longitude"];
    NSString* currentLoc = @"current%20location";

    NSString* url;

    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]];

    if (address != nil) {
        address = [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }

    if (canHandle) {
        // Google maps installed
        if (address != nil) {
            url = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@", currentLoc, address];
        } else {
            url = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@,%@", currentLoc, lat, lng];
        }
    } else {
        // Use Apple maps
        if (address != nil) {
            url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@", currentLoc, address];
        } else {
            url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@,%@", currentLoc, lat, lng];
        }
    }

    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:url];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
