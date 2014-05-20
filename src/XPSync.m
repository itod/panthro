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
        self.pauseChannel = [XPSynchronousChannel synchronousChannelWithPutPermit:YES];
        self.resumeChannel = [XPSynchronousChannel synchronousChannelWithPutPermit:YES];
    }
    return self;
}


- (void)dealloc {
    self.pauseChannel = nil;
    self.resumeChannel = nil;
    [super dealloc];
}


- (id)takePauseInfo {
    XPAssert(_pauseChannel);
    XPAssert(_resumeChannel);
    
    id info = [_pauseChannel take];
    return info;
}


- (void)putPauseInfo:(id)info {
    XPAssert(_pauseChannel);
    XPAssert(_resumeChannel);
    
    [_pauseChannel put:info];
}


- (id)takeResumeInfo {
    XPAssert(_pauseChannel);
    XPAssert(_resumeChannel);
    
    id info = [_resumeChannel take];
    return info;
}


- (void)putResumeInfo:(id)info {
    XPAssert(_pauseChannel);
    XPAssert(_resumeChannel);

    [_resumeChannel put:info];
}

@end
