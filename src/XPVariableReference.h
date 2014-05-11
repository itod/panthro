//
//  XPVariableReference.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Panthro/Panthro.h>

//@protocol XPBinding;

@interface XPVariableReference : XPExpression

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, copy) NSString *name;
//@property (nonatomic, retain, readonly) id <XPBinding>binding;
@end
