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

@interface XPUserFunction : XPValue <XPScope>

- (void)addParameter:(NSString *)paramName;
- (NSUInteger)numberOfParameters;

@property (nonatomic, retain) XPExpression *bodyExpression;
@end
