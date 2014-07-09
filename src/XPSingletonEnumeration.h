//
//  XPSingletonEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPAbstractNodeEnumeration.h"
#import "XPAxisEnumeration.h"

@interface XPSingletonEnumeration : XPAbstractNodeEnumeration <XPAxisEnumeration>

- (instancetype)initWithNode:(id <XPNodeInfo>)node;

@property (nonatomic, retain) id <XPNodeInfo>node;
@end
