//
//  PTLocalStorageImplementation.m
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 11/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import "PTLocalStorageImplementation.h"

static NSString *const kLocalStringKey = @"kLocalStringKey";


@implementation PTLocalStorageImplementation

#pragma mark - PTLocalStorage

- (void)saveString:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:kLocalStringKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)retrieveString {

    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalStringKey];
    return string;
}

- (BOOL)isEmpty {
    
    return ![[self retrieveString] length];
}

@end
