//
//  XPSynchronousChannel.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/19/14.
//
//

#import "XPSynchronousChannel.h"
#import "XPLocking.h"
#import "XPSemaphore.h"

@interface XPSynchronousChannel ()
@property (retain) XPSemaphore *putPermit;
@property (retain) XPSemaphore *takePermit;
@property (retain) id item;
@end

@implementation XPSynchronousChannel

+ (instancetype)synchronousChannelWithPutPermit:(BOOL)isPut {
    return [[[self alloc] initWithPutPermit:isPut] autorelease];
}


- (instancetype)initWithPutPermit:(BOOL)isPut {
    self = [super init];
    if (self) {
        self.putPermit = [XPSemaphore semaphoreWithValue:isPut ? 1 : 0];
        self.takePermit = [XPSemaphore semaphoreWithValue:isPut ? 0 : 1];
    }
    return self;
}


- (void)dealloc {
    self.putPermit = nil;
    self.takePermit = nil;
    self.item = nil;
    [super dealloc];
}


- (void)put:(id)obj {
    XPAssert(_putPermit);
    XPAssert(_takePermit);

    [_putPermit acquire];
    XPAssert(!_item);
    self.item = obj;
    [_takePermit relinquish];
}


- (id)take {
    XPAssert(_putPermit);
    XPAssert(_takePermit);
    
    [_takePermit acquire];
    XPAssert(_item);
    id obj = [[_item retain] autorelease];
    self.item = nil;
    [_putPermit relinquish];

    return obj;
}

@end
