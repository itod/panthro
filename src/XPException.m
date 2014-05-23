//
//  XPException.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/23/14.
//
//

#import "XPException.h"
#import "XPExpression.h"

@implementation XPException

+ (void)raiseIn:(XPExpression *)expr format:(NSString *)format, ... {
	va_list vargs;
	va_start(vargs, format);
	
	NSMutableString *reason = [[[NSMutableString alloc] initWithFormat:format arguments:vargs] autorelease];
	
	va_end(vargs);
    
    NSValue *range = [NSValue valueWithRange:expr.range];
    id info = @{NSLocalizedDescriptionKey: XPathExceptionName, NSLocalizedFailureReasonErrorKey: reason, XPathExceptionRangeKey: range};
    
    XPException *ex = [[[XPException alloc] initWithName:XPathExceptionName reason:reason userInfo:info] autorelease];
    [ex raise];
}

@end
