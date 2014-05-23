//
//  XPException.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/23/14.
//
//

#import "XPException.h"
#import "XPExpression.h"

NSString * const XPathExceptionName = @"XPath Exception";
NSString * const XPathExceptionRangeKey = @"range";
NSString * const XPathExceptionLineNumberKey = @"lineNumber";

@implementation XPException

+ (void)raiseWithFormat:(NSString *)format, ... {
	va_list vargs;
	va_start(vargs, format);
	
	NSMutableString *reason = [[[NSMutableString alloc] initWithFormat:format arguments:vargs] autorelease];
	
	va_end(vargs);
    
    NSValue *range = [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)];
    id info = @{NSLocalizedDescriptionKey: XPathExceptionName, NSLocalizedFailureReasonErrorKey: reason, XPathExceptionRangeKey: range};
    
    XPException *ex = [[[XPException alloc] initWithName:XPathExceptionName reason:reason userInfo:info] autorelease];
    ex.range = NSMakeRange(NSNotFound, 0);
    [ex raise];
}


+ (void)raiseIn:(XPExpression *)expr format:(NSString *)format, ... {
	va_list vargs;
	va_start(vargs, format);
	
	NSMutableString *reason = [[[NSMutableString alloc] initWithFormat:format arguments:vargs] autorelease];
	
	va_end(vargs);
    
    NSValue *range = [NSValue valueWithRange:expr.range];
    id info = @{NSLocalizedDescriptionKey: XPathExceptionName, NSLocalizedFailureReasonErrorKey: reason, XPathExceptionRangeKey: range};
    
    XPException *ex = [[[XPException alloc] initWithName:XPathExceptionName reason:reason userInfo:info] autorelease];
    ex.range = expr.range;
    [ex raise];
}

@end
