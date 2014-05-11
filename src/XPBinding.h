//
//  XPBinding.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Panthro/XPExpression.h>

@protocol XPBinding <NSObject>

/**
 * Determine whether this variable is global
 */

- (BOOL)isGlobal;

/**
 * Get the name of the variable, to use in diagnostics
 */

- (NSString *)variableName;

/**
 * Establish the fingerprint of the name of this variable.
 */

//- (NSUInteger)variableFingerprint;

/**
 * Determine a slot number for the variable.
 */

- (NSUInteger)slotNumber;

/**
 * Get the data type, if known statically. This will be a value such as Value.BOOLEAN,
 * Value.STRING. If the data type is not known statically, return Value.ANY.
 */

- (XPDataType)dataType;

/**
 * Get the value of the variable, if known statically. If the value is not known statically,
 * return null.
 */

- (XPValue *)constantValue;

/**
 * Determine whether the variable is assignable using saxon:assign
 */

- (BOOL)isAssignable;

@end
