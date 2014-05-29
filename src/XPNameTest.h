//
//  XPNameTest.h
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNodeTest.h"

@interface XPNameTest : XPNodeTest

- (instancetype)initWithNamespaceURI:(NSString *)nsURI localName:(NSString *)localName;

@property (nonatomic, copy, readonly) NSString *namespaceURI;
@property (nonatomic, copy, readonly) NSString *localName;
@end
