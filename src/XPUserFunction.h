//
//  XPUserFunction.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/13/14.
//
//

#import <Panthro/XPValue.h>
#import <Panthro/XPScope.h>

@class XPExpression;

@interface XPUserFunction : XPValue <NSCopying, XPScope>

- (instancetype)initWithName:(NSString *)name;

- (XPValue *)callInContext:(XPContext *)ctx;

- (void)addParameter:(NSString *)paramName;
- (NSUInteger)numberOfParameters;
- (NSString *)parameterAtIndex:(NSUInteger)i;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) XPExpression *bodyExpression;
@end
