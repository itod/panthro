//
//  XPPauseState.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/10/14.
//
//

#import "XPPauseState.h"

@interface XPPauseState ()
@property (nonatomic, retain) NSMutableArray *allContextNodes;
@property (nonatomic, retain) NSMutableArray *allResultNodes;
@end

@implementation XPPauseState

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allContextNodes = [NSMutableArray array];
        self.allResultNodes = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.allContextNodes = nil;
    self.allResultNodes = nil;
    [super dealloc];
}


- (void)addContextNode:(id <XPNodeInfo>)node {
    XPAssert(_allContextNodes);
    [_allContextNodes addObject:node];
}


- (void)addResultNodes:(NSArray *)nodes {
    XPAssert(_allResultNodes);
    [_allResultNodes addObjectsFromArray:nodes];
}


- (NSArray *)contextNodes {
    return [[_allContextNodes copy] autorelease];
}


- (NSArray *)resultNodes {
    return [[_allResultNodes copy] autorelease];
}

@end
