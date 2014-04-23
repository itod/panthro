//
//  XPAxis.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPAxis.h>
#import <XPath/XPNodeType.h>

/**
 * Table indicating the principal node type of each axis
 */

const NSUInteger XPAxisPrincipalNodeType[] =
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
NSUInteger XPAxisGetAxisNumber(NSString *name) {
    if ([name isEqualToString:@"ancestor"])                return XPAxisAncestor;
    if ([name isEqualToString:@"ancestor-or-self"])        return XPAxisAncestorOrSelf;
    if ([name isEqualToString:@"attribute"])               return XPAxisAttribute;
    if ([name isEqualToString:@"child"])                   return XPAxisChild;
    if ([name isEqualToString:@"descendant"])              return XPAxisDescendant;
    if ([name isEqualToString:@"descendant-or-self"])      return XPAxisDescendantOrSelf;
    if ([name isEqualToString:@"following"])               return XPAxisFollowing;
    if ([name isEqualToString:@"following-sibling"])       return XPAxisFollowingSibling;
    if ([name isEqualToString:@"namespace"])               return XPAxisNamespace;
    if ([name isEqualToString:@"parent"])                  return XPAxisParent;
    if ([name isEqualToString:@"preceding"])               return XPAxisPreceding;
    if ([name isEqualToString:@"preceding-sibling"])       return XPAxisPrecedingSibling;
    if ([name isEqualToString:@"self"])                    return XPAxisSelf;
    // preceding-or-ancestor cannot be used in an XPath expression
    [NSException raise:@"XPathException" format:@"Unknown axis name: %@", name];
    return 0;
}

