//
//  XPFunctionReference.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Panthro/Panthro.h>
#import <Panthro/XPCallable.h>

@interface XPFunctionCall : XPExpression <XPCallable>

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, copy) NSString *name;
@end
