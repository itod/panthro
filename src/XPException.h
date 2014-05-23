//
//  XPException.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/23/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPException : NSException

+ (void)raiseIn:(XPExpression *)expr format:(NSString *)format, ...;
@end
