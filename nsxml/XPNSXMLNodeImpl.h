//
//  XPNSXMLNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPNodeInfo.h"

@interface XPNSXMLNodeImpl : NSObject <XPNodeInfo>

- (instancetype)initWithNode:(NSXMLNode *)node sortIndex:(NSInteger)idx;

@property (nonatomic, retain, readonly) NSXMLNode *node;
@property (nonatomic, assign, readonly) NSInteger sortIndex;
@end
