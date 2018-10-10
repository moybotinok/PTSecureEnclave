//
//  PTLocalStorage.h
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 11/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PTLocalStorage <NSObject>

- (void)saveString:(NSString *)string;

- (NSString *)retrieveString;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
