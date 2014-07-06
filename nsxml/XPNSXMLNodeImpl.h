//
//  XPNSXMLNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPAbstractNodeWrapper.h"

@interface XPNSXMLNodeImpl : XPAbstractNodeWrapper

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)node;
- (id <XPNodeInfo>)initWithNode:(void *)node;

@property (nonatomic, retain) id node;
@end
