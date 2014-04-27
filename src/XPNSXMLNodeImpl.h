//
//  XPNSXMLNodeImpl.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import <XPath/XPNodeInfo.h>

@interface XPNSXMLNodeImpl : NSObject <XPNodeInfo>

- (instancetype)initWithNode:(NSXMLNode *)node;

@property (nonatomic, retain) NSXMLNode *node;
@end
