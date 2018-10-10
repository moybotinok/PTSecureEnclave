//
//  AppDelegate.m
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 10/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "PTSecureEnclaveServiceImplementation.h"
#import "PTLocalStorageImplementation.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    PTSecureEnclaveServiceImplementation *secureEnclaveServiceImplementation =  [[PTSecureEnclaveServiceImplementation alloc] init];
    secureEnclaveServiceImplementation.delegate = viewController;
    viewController.secureEnclaveService = secureEnclaveServiceImplementation;
    viewController.localStorage = [[PTLocalStorageImplementation alloc] init];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
