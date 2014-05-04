//
//  XPStaticContext.h
//  XPath
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class XPNamePool;
@class XPNameTest;
@class XPNamespaceTest;
@class XPBinding;

@protocol XPStaticContext <NSObject>

//- (id <XPStaticContext>)copyRuntimeContextWithNamePool:(XPNamePool *)pool;

- (NSString *)systemId;

- (NSInteger)lineNumber;

- (NSString *)baseURI;

- (NSString *)namespaceURIForPrefix:(NSString *)prefix error:(NSError **)err;

- (NSInteger)makeNameCode:(NSString *)qname useDefault:(BOOL)useDefault error:(NSError **)err;
//
//- (NSInteger)fingerprintForElementNamed:(NSString *)qname useDefault:(BOOL)useDefault error:(NSError **)err;
//
- (XPNameTest *)makeNameTestForNodeType:(short)nodeType qname:(NSString *)qname useDefault:(BOOL)useDefault error:(NSError **)err;

- (XPNamespaceTest *)makeNamespaceTestForNodeType:(short)nodeType prefix:(NSString *)prefix error:(NSError **)err;
//
//- (XPBinding *)bindVariable:(NSInteger)fingerprint error:(NSError **)err;

- (BOOL)isExtensionNamespace:(short)uriCode error:(NSError **)err;

- (BOOL)forwardsCompatibleModeIsEnabled:(NSError **)err;

- (BOOL)getStyleSheetFunction:(NSInteger)fingerprint error:(NSError **)err;

- (Class)externalCocoaClass:(NSString *)uri error:(NSError **)err;

- (BOOL)isElementAvailable:(NSString *)qname error:(NSError **)err;

- (BOOL)isFunctionAvailable:(NSString *)qname error:(NSError **)err;

- (BOOL)allowsKeyFunction;

- (NSString *)version;
@end
