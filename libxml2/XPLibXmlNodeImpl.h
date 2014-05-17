//
//  XPLibxmlNodeImpl.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import <Panthro/XPNodeInfo.h>

@interface XPLibxmlNodeImpl : NSObject <XPNodeInfo>

+ (id <XPNodeInfo>)nodeInfoWithNode:(void *)node;
- (id <XPNodeInfo>)initWithNode:(void *)node;

@end
