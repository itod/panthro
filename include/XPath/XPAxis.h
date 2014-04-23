//
//  XPAxis.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <Foundation/Foundation.h>

/**
 * An axis, that is a direction of navigation in the document structure.
 */


/**
* Constants representing the axes
*/
typedef NS_ENUM(NSUInteger, XPAxis) {
    XPAxisAncestor           = 0,
    XPAxisAncestorOrSelf     = 1,
    XPAxisAttribute          = 2,
    XPAxisChild              = 3,
    XPAxisDescendant         = 4,
    XPAxisDescendantOrSelf   = 5,
    XPAxisFollowing          = 6,
    XPAxisFollowingSibling   = 7,
    XPAxisNamespace          = 8,
    XPAxisParent             = 9,
    XPAxisPreceding          = 10,
    XPAxisPrecedingSibling   = 11,
    XPAxisSelf               = 12,
    
    // preceding-or-ancestor axis gives all preceding nodes including ancestors,
    // in reverse document order
    
    XPAxisPrecedingOrAncestor = 13,
};



/**
 * Table indicating the principal node type of each axis
 */

extern const NSUInteger XPAxisPrincipalNodeType[];

/**
* Table indicating for each axis whether it is in forwards document order
*/

extern const BOOL XPAxisIsForwards[];

/**
* Table indicating for each axis whether it is in reverse document order
*/

extern const BOOL XPAxisIsReverse[];

/**
* Table indicating for each axis whether it is a peer axis. An axis is a peer
* axis if no node on the axis is an ancestor of another node on the axis.
*/

extern const BOOL XPAxisIsPeerAxis[];

/**
* Table indicating for each axis whether it is contained within the subtree
* rooted at the origin node.
*/

extern const BOOL XPAxisIsSubtreeAxis[];

/**
* Table giving the name each axis
*/

extern const NSString *XPAxisName[];

/**
* Resolve an axis name into a symbolic constant representing the axis
*/

extern NSUInteger XPAxisGetAxisNumber(NSString *name);

/*
    // a list for any future cut-and-pasting...
    ANCESTOR
    ANCESTOR_OR_SELF;
    ATTRIBUTE;
    CHILD;
    DESCENDANT;
    DESCENDANT_OR_SELF;
    FOLLOWING;
    FOLLOWING_SIBLING;
    NAMESPACE;
    PARENT;
    PRECEDING;
    PRECEDING_SIBLING;
    SELF;
*/





