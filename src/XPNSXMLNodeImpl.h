//
//  XPNSXMLNodeImpl.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import <XPath/XPNodeInfo.h>

@interface XPNSXMLNodeImpl : NSObject <XPNodeInfo>

- (instancetype)initWithNode:(NSXMLNode *)node sortIndex:(NSUInteger)idx;

@property (nonatomic, retain, readonly) NSXMLNode *node;
@property (nonatomic, assign, readonly) NSUInteger sortIndex;
@end
