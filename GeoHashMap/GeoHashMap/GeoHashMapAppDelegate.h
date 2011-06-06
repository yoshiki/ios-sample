//
//  GeoHashMapAppDelegate.h
//  GeoHashMap
//
//  Created by Yoshiki Kurihara on 11/06/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeoHashMapViewController;

@interface GeoHashMapAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GeoHashMapViewController *viewController;

@end
