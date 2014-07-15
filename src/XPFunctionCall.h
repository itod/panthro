//
//  XPFunctionReference.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Panthro/Panthro.h>
#import <Panthro/XPCallable.h>

@class XPVariableReference;

@interface XPFunctionCall : XPExpression <XPCallable>

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithVariableReference:(XPExpression *)ref;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) XPExpression *variableReference;
@end
