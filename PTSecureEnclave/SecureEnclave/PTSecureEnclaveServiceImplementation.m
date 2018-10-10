//
//  PTSecureEnclaveServiceImplementation.m
//  PTSecureEnclave
//
//  Created by Tatiana Paushkina on 11/10/2018.
//  Copyright © 2018 tany. All rights reserved.
//

#import "PTSecureEnclaveServiceImplementation.h"
#import "PTSecureEnclaveServiceDelegate.h"

static NSString *const kKeyTag = @"com.tany.paushkina.PTSecureEnclave.KeyTag";
static NSInteger const kMaxDataSize = 256;

@implementation PTSecureEnclaveServiceImplementation

#pragma mark - PTSecureEnclaveService

- (void)encryptString:(NSString *)string {
    
    SecKeyRef privateKey = [self retriveKey];
    if (!privateKey) {
        privateKey = [self createPrivateKey];
        [self storeKey:privateKey];
    }
    
    SecKeyRef publicKey = [self createPublicKeyWithPrivateKey:privateKey];
    [self releaseKey:privateKey];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self encryptItem:data withPublicKey:publicKey];
    
    [self releaseKey:publicKey];
    
    [self.delegate encryptWithSuccess:result];
}

- (void)decryptString:(NSString *)string {
    
    SecKeyRef privateKey = [self retriveKey];
    
    if (!privateKey) {

        [self.delegate didFailureDecriptionWithErrorMessage:@"Отсутствует ключ для расшифровки"];
        return;
    }
    
    NSString *result = [self decryptString:string withKey:privateKey];
    
    [self releaseKey:privateKey];
    
    if (![result length]) {
        
        [self.delegate didFailureDecriptionWithErrorMessage:@"Не удалось расшифровать"];
    }
    
    [self.delegate decryptWithSuccess:result];
}


#pragma mark - Private

- (NSDictionary *)keyAttributes {
    
    CFErrorRef errorRef = NULL;
    SecAccessControlRef accessControlRef = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, kSecAccessControlPrivateKeyUsage, &errorRef);
    
    if (accessControlRef == NULL || errorRef != NULL) {
        NSError *error = CFBridgingRelease(errorRef);
        NSLog(@"ERROR: cant create AccessControlRef:\n%@", error);
        return nil;
    }
    
    NSDictionary* attributes = @{
                                 (id)kSecAttrKeyType:       (id)kSecAttrKeyTypeEC,
                                 (id)kSecAttrKeySizeInBits: @(kMaxDataSize),
                                 (id)kSecAttrTokenID:       (id)kSecAttrTokenIDSecureEnclave,
                                 (id)kSecPrivateKeyAttrs: @{
                                         (id)kSecAttrIsPermanent:   @YES,
                                         (id)kSecAttrAccessControl: (__bridge id) accessControlRef}
                                 };
    
    return attributes;
}

- (SecKeyRef)createPrivateKey {
    
    NSDictionary *attributes = [self keyAttributes];
    
    CFErrorRef errorRef = NULL;
    SecKeyRef privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes, &errorRef);
    
    if (!privateKey) {
        NSError *error = CFBridgingRelease(errorRef);
        NSLog(@"ERROR cant create private key:\n%@", error);
        return NULL;
    }
    
    return privateKey;
}

- (SecKeyRef)createPublicKeyWithPrivateKey:(SecKeyRef)privateKey {
    
    SecKeyRef publicKey = SecKeyCopyPublicKey(privateKey);
    return publicKey;
}

- (SecKeyAlgorithm)algorithm {
    
    return kSecKeyAlgorithmECIESEncryptionStandardX963SHA256AESGCM;
}

- (NSString *)encryptItem:(NSData *)item withPublicKey:(SecKeyRef)publicKey {
    
    BOOL canEncrypt = SecKeyIsAlgorithmSupported(publicKey, kSecKeyOperationTypeEncrypt, [self algorithm]);
    
    if (!canEncrypt) {
        
        NSLog(@"ERROR private key cant encrypt with algorithm");
        return nil;
    }
    
    if (item.length > kMaxDataSize) {
        
        NSLog(@"ERROR too big data, cant encrypt");
        return nil;
    }
    
    NSData *encriptedData = nil;
    CFErrorRef errorRef = NULL;
    encriptedData = (NSData*)CFBridgingRelease(SecKeyCreateEncryptedData(publicKey,[self algorithm], (__bridge CFDataRef)item, &errorRef));
    
    if (!encriptedData) {
        
        NSError *error = CFBridgingRelease(errorRef);
        NSLog(@"ERROR cant encrypt:\n%@", error);
        return nil;
    }
    
    NSString *encriptedString = [encriptedData base64EncodedStringWithOptions:0];
    return encriptedString;
}

- (NSString *)decryptString:(NSString *)string withKey:(SecKeyRef)key {
    
    BOOL canDecrypt = SecKeyIsAlgorithmSupported(key, kSecKeyOperationTypeDecrypt, [self algorithm]);
    
    if (!canDecrypt) {
        NSLog(@"ERROR key cant decrypt with algorithm");
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    
    NSData *decryptData = nil;
    CFErrorRef errorRef = NULL;
    decryptData = (NSData*)CFBridgingRelease(SecKeyCreateDecryptedData(key, [self algorithm],  (__bridge CFDataRef)data, &errorRef));
    
    if (!decryptData) {
        
        NSError *error = CFBridgingRelease(errorRef);
        NSLog(@"ERROR cant decrypt:\n%@", error);
        return nil;
    }
    
    NSString *decryptString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
}

#pragma mark - Store

- (NSData *)keyTag {
    
    return [kKeyTag dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)storeKey:(SecKeyRef)key {
    
    NSDictionary* query = @{(id)kSecValueRef: (__bridge id)key,
                            (id)kSecClass: (id)kSecClassKey,
                            (id)kSecAttrApplicationTag: [self keyTag],
                            };
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    
    if (status != errSecSuccess) {
        
        NSLog(@"ERROR cant store key");
    }
}

- (SecKeyRef)retriveKey {
    
    NSDictionary *query = @{(id)kSecClass: (id)kSecClassKey,
                            (id)kSecAttrApplicationTag: [self keyTag],
                            (id)kSecReturnRef: @YES,
                            };
    
    SecKeyRef key = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,  (CFTypeRef *)&key);
    
    if (status != errSecSuccess) {
        
        NSLog(@"ERROR cant retrive key");
        return NULL;
    }
    
    return key;
}

- (void)releaseKey:(SecKeyRef)key {
    
    if (key) {
        CFRelease(key);
    }
}

@end
