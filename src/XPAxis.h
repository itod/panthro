//
//  XPAxis.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPNodeInfo.h>

/**
 * An axis, that is a direction of navigation in the document structure.
 */


/**
* Constants representing the axes
*/
typedef NS_ENUM(uint8_t, XPAxis) {
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

const uint8_t XPAxisPrincipalNodeType[] =
{
    XPNodeTypeElement,       // ANCESTOR
    XPNodeTypeElement,       // ANCESTOR_OR_SELF;
    XPNodeTypeAttribute,     // ATTRIBUTE;
    XPNodeTypeElement,       // CHILD;
    XPNodeTypeElement,       // DESCENDANT;
    XPNodeTypeElement,       // DESCENDANT_OR_SELF;
    XPNodeTypeElement,       // FOLLOWING;
    XPNodeTypeElement,       // FOLLOWING_SIBLING;
    XPNodeTypeNamespace,     // NAMESPACE;
    XPNodeTypeElement,       // PARENT;
    XPNodeTypeElement,       // PRECEDING;
    XPNodeTypeElement,       // PRECEDING_SIBLING;
    XPNodeTypeElement,       // SELF;
    XPNodeTypeElement,       // PRECEDING_OR_ANCESTOR;
};


    /**
    * Table indicating for each axis whether it is in forwards document order
    */

const BOOL XPAxisIsForwards[] =
{
    NO,          // ANCESTOR
    NO,          // ANCESTOR_OR_SELF;
    YES,         // ATTRIBUTE;
    YES,         // CHILD;
    YES,         // DESCENDANT;
    YES,         // DESCENDANT_OR_SELF;
    YES,         // FOLLOWING;
    YES,         // FOLLOWING_SIBLING;
    NO,          // NAMESPACE;
    YES,         // PARENT;
    NO,          // PRECEDING;
    NO,          // PRECEDING_SIBLING;
    YES,         // SELF;
    NO,          // PRECEDING_OR_ANCESTOR;
};

    /**
    * Table indicating for each axis whether it is in reverse document order
    */

const BOOL XPAxisIsReverse[] =
{
    YES,         // ANCESTOR
    YES,         // ANCESTOR_OR_SELF;
    NO,          // ATTRIBUTE;
    NO,          // CHILD;
    NO,          // DESCENDANT;
    NO,          // DESCENDANT_OR_SELF;
    NO,          // FOLLOWING;
    NO,          // FOLLOWING_SIBLING;
    NO,          // NAMESPACE;
    YES,         // PARENT;
    YES,         // PRECEDING;
    YES,         // PRECEDING_SIBLING;
    YES,         // SELF;
    YES,         // PRECEDING_OR_ANCESTOR;
};

    /**
    * Table indicating for each axis whether it is a peer axis. An axis is a peer
    * axis if no node on the axis is an ancestor of another node on the axis.
    */

const BOOL XPAxisIsPeerAxis[] =
{
    NO,          // ANCESTOR
    NO,          // ANCESTOR_OR_SELF;
    YES,         // ATTRIBUTE;
    YES,         // CHILD;
    NO,          // DESCENDANT;
    NO,          // DESCENDANT_OR_SELF;
    NO,          // FOLLOWING;             # TODO: old code said YES... #
    YES,         // FOLLOWING_SIBLING;
    NO,          // NAMESPACE;
    YES,         // PARENT;
    NO,          // PRECEDING;
    YES,         // PRECEDING_SIBLING;
    YES,         // SELF;
    NO,          // PRECEDING_OR_ANCESTOR;
};

/**
* Table indicating for each axis whether it is contained within the subtree
* rooted at the origin node.
*/

const BOOL XPAxisIsSubtreeAxis[] =
{
    NO,          // ANCESTOR
    NO,          // ANCESTOR_OR_SELF;
    YES,         // ATTRIBUTE;
    YES,         // CHILD;
    YES,         // DESCENDANT;
    YES,         // DESCENDANT_OR_SELF;
    NO,          // FOLLOWING;
    NO,          // FOLLOWING_SIBLING;
    NO,          // NAMESPACE;
    NO,          // PARENT;
    NO,          // PRECEDING;
    NO,          // PRECEDING_SIBLING;
    YES,         // SELF;
    NO,          // PRECEDING_OR_ANCESTOR;
};

/**
* Table giving the name each axis
*/

const NSString *XPAxisName[] =
{
    @"ancestor",             // ANCESTOR
    @"ancestor-or-self",     // ANCESTOR_OR_SELF;
    @"attribute",            // ATTRIBUTE;
    @"child",                // CHILD;
    @"descendant",           // DESCENDANT;
    @"descendant-or-self",   // DESCENDANT_OR_SELF;
    @"following",            // FOLLOWING;
    @"following-sibling",    // FOLLOWING_SIBLING;
    @"namespace",            // NAMESPACE;
    @"parent",               // PARENT;
    @"preceding",            // PRECEDING;
    @"preceding-sibling",    // PRECEDING_SIBLING;
    @"self",                 // SELF;
    @"preceding-or-ancestor",// PRECEDING_OR_ANCESTOR;
};

/**
* Resolve an axis name into a symbolic constant representing the axis
*/

extern uint8_t XPAxisGetAxisNumber(NSString *name);

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





