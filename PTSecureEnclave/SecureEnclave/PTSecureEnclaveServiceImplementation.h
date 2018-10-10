//
//  PTSecureEnclaveServiceImplementation.h
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 11/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTSecureEnclaveService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PTSecureEnclaveServiceDelegate;

@interface PTSecureEnclaveServiceImplementation : NSObject <PTSecureEnclaveService>

@property (weak, nonatomic) id<PTSecureEnclaveServiceDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
