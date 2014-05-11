//
//  XPBindery.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import "XPBindery.h"
#import "XPBinding.h"

@interface XPBindery ()
@property (nonatomic, retain) NSMutableDictionary *vars;
@end

@implementation XPBindery

- (instancetype)init {
    self = [super init];
    if (self) {
        self.vars = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.vars = nil;
    [super dealloc];
}


- (void)setValue:(XPValue *)val forVariable:(id <XPBinding>)binding {
    NSParameterAssert(val);
    NSParameterAssert(binding);
    XPAssert(_vars);
    
    [_vars setObject:val forKey:[binding variableName]];
}


- (XPValue *)valueForVariable:(id <XPBinding>)binding {
    NSParameterAssert(binding);
    XPAssert(_vars);
    
    return [_vars objectForKey:[binding variableName]];
}

@end
