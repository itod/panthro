//
//  XPNodeSetValueEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPAbstractNodeEnumeration.h"
#import "XPAxisEnumeration.h"
#import "XPPauseHandler.h"

@interface XPNodeSetValueEnumeration : XPAbstractNodeEnumeration <XPAxisEnumeration, XPPauseHandler>

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted isReverseSorted:(BOOL)reverseSorted;

@property (nonatomic, copy) NSArray *nodes;
@end
