//
//  XPDocumentInfo.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNodeInfo.h"

@protocol XPDocumentInfo <XPNodeInfo>

/**
 * Get the element with a given ID, if any
 * @param identifier the required ID value
 * @return the element with the given ID, or null if there is no such ID present (or if the parser
 * has not notified attributes as being of type ID)
 */

- (id <XPNodeInfo>)selectID:(NSString *)identifier;

@end
