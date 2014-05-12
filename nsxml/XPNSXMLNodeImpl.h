//
//  XPNSXMLNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPNodeInfo.h"

@interface XPNSXMLNodeImpl : NSObject <XPNodeInfo>

- (instancetype)initWithNode:(NSXMLNode *)node;

@property (nonatomic, retain, readonly) NSXMLNode *node;
@end
