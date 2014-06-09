//
//  XPSync.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/19/14.
//
//

#import "XPSync.h"
#import "XPSynchronousChannel.h"

@interface XPSync ()
@property (retain) XPSynchronousChannel *pauseChannel;
@property (retain) XPSynchronousChannel *resumeChannel;
@end

@implementation XPSync

+ (instancetype)sync {
    return [[[self alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.pauseChannel = [XPSynchronousChannel synchronousChannel];
        self.resumeChannel = [XPSynchronousChannel synchronousChannel];
    }
    return self;
}


- (void)dealloc {
    self.pauseChannel = nil;
    self.resumeChannel = nil;
    [super dealloc];
}


- (id)awaitPause {
    XPAssert(_pauseChannel);
    return [_pauseChannel take];
}


- (void)pauseWithInfo:(id)info {
    XPAssert(_pauseChannel);
    [_pauseChannel put:info];
}


- (id)awaitResume {
    XPAssert(_resumeChannel);
    return [_resumeChannel take];
}


- (void)resumeWithInfo:(id)info {
    XPAssert(_resumeChannel);
    [_resumeChannel put:info];
}

@end
