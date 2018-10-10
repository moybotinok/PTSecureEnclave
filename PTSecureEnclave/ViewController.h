//
//  ViewController.h
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 10/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSecureEnclaveServiceDelegate.h"

@protocol PTSecureEnclaveService, PTLocalStorage;

@interface ViewController : UIViewController <PTSecureEnclaveServiceDelegate>

@property (strong, nonatomic) id<PTSecureEnclaveService> secureEnclaveService;
@property (strong, nonatomic) id<PTLocalStorage> localStorage;

@end

