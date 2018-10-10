//
//  PTSecureEnclaveServiceDelegate.h
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 11/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PTSecureEnclaveServiceDelegate <NSObject>

- (void)encryptWithSuccess:(NSString *)encryptedString;
- (void)didFailureEncriptionWithErrorMessage:(NSString *)errorMessage;

- (void)decryptWithSuccess:(NSString *)decryptedString;
- (void)didFailureDecriptionWithErrorMessage:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END
