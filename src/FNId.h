//
//  FNId.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPFunction.h"

@protocol XPDocumentInfo;

@interface FNId : XPFunction

@property (nonatomic, retain) id <XPDocumentInfo>boundDocument;
@end
