//
//  ViewController.m
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 10/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import "ViewController.h"
#import "PTSecureEnclaveService.h"
#import "PTLocalStorage.h"

static NSString *const kEmptyEncryptTextErrorMessage = @"Введите текст для шифрования.";


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UILabel *decryptedLabel;
@property (weak, nonatomic) IBOutlet UIButton *decryptButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateButtonView];
}

#pragma mark - Actions

- (IBAction)encryptButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *text = self.textFiled.text;
    
    if (![text length]) {
        
        [self showMessage:kEmptyEncryptTextErrorMessage];
        
    } else {
        
        [self.secureEnclaveService encryptString:text];
    }
}

- (IBAction)decryptButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *encryptedText = [self.localStorage retrieveString];
    if ([encryptedText length]) {
        
        [self.secureEnclaveService decryptString:encryptedText];
    }
}

#pragma mark - PTSecureEnclaveServiceDelegate

- (void)encryptWithSuccess:(NSString *)encryptedString {
    
    [self.localStorage saveString:encryptedString];
    [self updateButtonView];
}

- (void)didFailureEncriptionWithErrorMessage:(NSString *)errorMessage {
    
    [self showMessage:errorMessage];
}

- (void)decryptWithSuccess:(NSString *)decryptedString {
    
    self.decryptedLabel.text = decryptedString;
}

- (void)didFailureDecriptionWithErrorMessage:(NSString *)errorMessage {
    
    [self showMessage:errorMessage];
}


#pragma mark - Private

- (void)updateButtonView {
    
    self.decryptButton.enabled = ![self.localStorage isEmpty];
}

- (void)showMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
