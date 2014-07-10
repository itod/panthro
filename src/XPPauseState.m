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
    self.expression = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ \nContextNodes:\n    %@\nResultNodes:\n    %@>", [self class], _allContextNodes, _allResultNodes];
}


- (void)addContextNode:(id <XPItem>)node {
    XPAssert(_allContextNodes);
    [_allContextNodes addObject:node];
}


- (void)addContextNodes:(NSArray *)nodes {
    XPAssert(_allContextNodes);
    [_allContextNodes addObjectsFromArray:nodes];
}


- (void)addResultNode:(id <XPItem>)node {
    XPAssert(_allResultNodes);
    [_allResultNodes addObject:node];
}


- (void)addResultNodes:(NSArray *)nodes {
    XPAssert(_allResultNodes);
    [_allResultNodes addObjectsFromArray:nodes];
}


- (void)addPauseState:(XPPauseState *)state {
    XPAssert(state);
    [self addContextNodes:state.contextNodes];
    [self addResultNodes:state.resultNodes];
}


- (NSArray *)contextNodes {
    return [[_allContextNodes copy] autorelease];
}


- (NSArray *)resultNodes {
    return [[_allResultNodes copy] autorelease];
}

@end
