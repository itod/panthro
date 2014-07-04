//
//  XPNSXMLNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPAbstractItem.h"
#import <Panthro/XPNodeInfo.h>

@interface XPNSXMLNodeImpl : XPAbstractItem <XPNodeInfo>

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)node;
- (id <XPNodeInfo>)initWithNode:(void *)node;

@property (nonatomic, retain) id node;
@end
