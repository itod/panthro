//
//  XPStaticContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPNameTest;
@class XPNamespaceTest;
@class XPValue;
@class XPSync;
@class XPFunction;

@protocol XPStaticContext <NSObject>

- (NSString *)systemId;
- (NSUInteger)lineNumber;
- (NSString *)baseURI;

- (NSString *)namespaceURIForPrefix:(NSString *)prefix;
- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix;

- (XPFunction *)makeSystemFunction:(NSString *)name;

- (BOOL)isElementAvailable:(NSString *)qname;
- (BOOL)isFunctionAvailable:(NSString *)qname;

- (NSString *)version;

- (void)setValue:(XPValue *)val forVariable:(NSString *)name;
- (XPValue *)valueForVariable:(NSString *)name;

@property (retain, readonly) XPSync *debugSync;
@property (assign) BOOL debug;
@end
