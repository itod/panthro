//
//  XPNameTest.h
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNodeTest.h"

@interface XPNameTest : XPNodeTest

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, copy, readonly) NSString *name;
@end
