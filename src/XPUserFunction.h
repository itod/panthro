//
//  XPUserFunction.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/13/14.
//
//

#import <Panthro/XPValue.h>
#import <Panthro/XPScope.h>
#import <Panthro/XPCallable.h>

@class XPExpression;

@interface XPUserFunction : XPValue <NSCopying, XPScope, XPCallable>

- (instancetype)initWithName:(NSString *)name;

- (void)addParameter:(NSString *)paramName;
- (NSUInteger)numberOfParameters;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) XPExpression *bodyExpression;
@end
