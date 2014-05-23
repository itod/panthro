//
//  XPException.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/23/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

extern NSString * const XPathExceptionName;
extern NSString * const XPathExceptionRangeKey;
extern NSString * const XPathExceptionLineNumberKey;

@interface XPException : NSException

@property (nonatomic, assign) NSRange range;

+ (void)raiseWithFormat:(NSString *)format, ...;
+ (void)raiseIn:(XPExpression *)expr format:(NSString *)format, ...;

@end
