//
//  PTSecureEnclaveService.h
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 11/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PTSecureEnclaveServiceDelegate;

@protocol PTSecureEnclaveService <NSObject>

@property (weak, nonatomic) id<PTSecureEnclaveServiceDelegate> delegate;

- (void)encryptString:(NSString *)string;

- (void)decryptString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
