//
//  XPUserFunction.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/13/14.
//
//

#import "XPUserFunction.h"
#import "XPContext.h"

@interface XPUserFunction ()
@property (nonatomic, retain) NSMutableArray *params;
@property (nonatomic, retain) NSMutableDictionary *variables;
@property (nonatomic, retain) XPContext *currentContext;
@end

@implementation XPUserFunction

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)dealloc {
    self.bodyExpression = nil;
    self.params = nil;
    self.variables = nil;
    [super dealloc];
}


- (void)addParameter:(NSString *)paramName {
    if (!_params) {
        self.params = [NSMutableArray array];
    }
    
    [_params addObject:paramName];
}


- (NSUInteger)numberOfParameters {
    return [_params count];
}


#pragma mark -
#pragma mark XPValue

- (XPDataType)dataType {
    return XPDataTypeAny;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    self.currentContext = ctx;
    return [_bodyExpression evaluateInContext:ctx];
}


#pragma mark -
#pragma mark XPScope

- (void)setItem:(id <XPItem>)item forVariable:(NSString *)name {
    NSParameterAssert([name length]);
    
    if (!_variables) {
        self.variables = [NSMutableDictionary dictionary];
    }
    
    XPAssert(_variables);
    
    if (!item) {
        [_variables removeObjectForKey:name];
    } else {
        [_variables setObject:item forKey:name];
    }
}


- (id <XPItem>)itemForVariable:(NSString *)name {
    NSParameterAssert(name);
    
    id <XPItem>item = [_variables objectForKey:name];
    if (!item) {
        item = [self.enclosingScope itemForVariable:name];
    }
    
    return item;
}


- (id <XPScope>)enclosingScope {
    XPAssert(_currentContext);
    return _currentContext;
}
@end
