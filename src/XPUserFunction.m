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
@property (nonatomic, retain) NSMutableDictionary *vars;
@property (nonatomic, retain) XPContext *currentContext;
@end

@implementation XPUserFunction

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.bodyExpression = nil;
    self.params = nil;
    self.vars = nil;
    self.currentContext = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, self.name];
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XPUserFunction *expr = [super copyWithZone:zone];
    expr.name = _name;
    expr.bodyExpression = [[_bodyExpression copy] autorelease];
    expr.params = [[_params mutableCopy] autorelease];
    // ignore vars
    // ignore curr ctx
    return expr;
}


- (void)addParameter:(NSString *)paramName {
    if (!_params) {
        self.params = [NSMutableArray arrayWithCapacity:6];
    }
    
    [_params addObject:paramName];
}


- (NSUInteger)numberOfParameters {
    return [_params count];
}


- (NSString *)parameterAtIndex:(NSUInteger)i {
    XPAssert(NSNotFound != i);
    XPAssert(i < [self numberOfParameters]);
    
    return _params[i];
}


#pragma mark -
#pragma mark XPValue

- (XPDataType)dataType {
    return XPDataTypeAny;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return self;
}


- (XPValue *)callInContext:(XPContext *)ctx {
    NSParameterAssert(ctx);
    XPAssert(_bodyExpression);

    self.currentContext = ctx;
    
    [ctx push:self];
    
    XPValue *result = [_bodyExpression evaluateInContext:ctx];
    
    [ctx pop];
    
    return result;
}


#pragma mark -
#pragma mark XPScope

- (void)setItem:(id <XPItem>)item forVariable:(NSString *)name {
    NSParameterAssert([name length]);
    
    if (!_vars) {
        self.vars = [NSMutableDictionary dictionary];
    }
    
    XPAssert(_vars);
    
    if (!item) {
        [_vars removeObjectForKey:name];
    } else {
        [_vars setObject:item forKey:name];
    }
}


- (id <XPItem>)itemForVariable:(NSString *)name {
    NSParameterAssert(name);
    
    id <XPItem>item = [_vars objectForKey:name];
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
