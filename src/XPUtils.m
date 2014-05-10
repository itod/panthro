//
//  XPUtils.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPUtils.h"
#import "XPSortable.h"

const NSString *XPNodeTypeName[] = {
    @"node",
    @"element",
    @"attribute",
    @"text",
    @"processing-instruction",
    @"comment",
    @"root",
    @"namespace",
    @"number-of-types",
    @"none",
};


static BOOL XPCharIsNCNameStart(unichar ch) {
    static NSMutableCharacterSet *set = nil;
    if (!set) {
        set = [[NSMutableCharacterSet characterSetWithCharactersInString:@"_"] retain]; // ?
        [set formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    }
    return [set characterIsMember:ch];
}


static BOOL XPCharIsNCName(unichar ch) {
    static NSMutableCharacterSet *set = nil;
    if (!set) {
        set = [[NSMutableCharacterSet characterSetWithCharactersInString:@"_-"] retain];
        [set formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    }
    return [set characterIsMember:ch];
}


    /**
     * Validate whether a given string constitutes a valid NCName, as defined in XML Namespaces
     */
    
BOOL XPNameIsNCName(NSString *name) {
    NSUInteger len = [name length];
    if (0 == len) return NO;

    unichar ch = [name characterAtIndex:0];
    if (!XPCharIsNCNameStart(ch)) return NO;
    
    for (NSUInteger i = 1; i < len; i++ ) {
        ch = [name characterAtIndex:i];
            if (!XPCharIsNCName(ch)) {
            return NO;
        }
    }
    return YES;
}
    
    /**
     * Validate whether a given string constitutes a valid QName, as defined in XML Namespaces
     */

BOOL XPNameIsQName(NSString *name) {
    NSUInteger colon = [name rangeOfString:@":"].location;
    if (NSNotFound == colon) return XPNameIsNCName(name);
    if (colon==0 || colon==[name length]-1) return NO;
    if (!XPNameIsNCName([name substringToIndex:colon])) return NO;
    if (!XPNameIsNCName([name substringFromIndex:(colon+1)])) return NO;
    return YES;
}
    
	/**
     * Extract the prefix from a QName. Note, the QName is assumed to be valid.
     */
    
BOOL XPNameGetPrefix(NSString *qname) {
    NSUInteger colon = [qname rangeOfString:@":"].location;
    if (NSNotFound == colon) {
        return @"";
    }
    return [qname substringToIndex:colon];
}
    
	/**
     * Extract the local name from a QName. The QName is assumed to be valid.
     */
    
BOOL XPNameGetLocalName(NSString *qname) {
    NSUInteger colon = [qname rangeOfString:@":"].location;
    if (NSNotFound == colon) {
        return @"";
    }
    return [qname substringFromIndex:(colon+1)];
}


/**
 * This is a generic version of C.A.R Hoare's Quick Sort
 * algorithm.  This will handle arrays that are already
 * sorted, and arrays with duplicate keys.<p>
 *
 * @author: Patrick C. Beard (beard@netscape.com)
 * Java Runtime Enthusiast -- "Will invoke interfaces for food."
 *
 * This code reached me (Michael Kay) via meteko.com; I'm assuming that it's OK
 * to use because they copied it freely to me.
 *
 * Modified by MHK in May 2001 to sort any object that implements the Sortable
 * interface, not only an array.
 *
 */

    /** This is a generic version of C.A.R Hoare's Quick Sort
     * algorithm.  This will handle arrays that are already
     * sorted, and arrays with duplicate keys.<BR>
     *
     * If you think of a one dimensional array as going from
     * the lowest index on the left to the highest index on the right
     * then the parameters to this function are lowest index or
     * left and highest index or right.  The first time you call
     * this function it will be with the parameters 0, a.length - 1.
     *
     * @param a       a Sortable object
     * @param lo0     index of first element (initially typically 0)
     * @param hi0     index of last element (initially typically length-1)
     */
    
void XPQuickSort(id <XPSortable>a, NSInteger lo0, NSInteger hi0) {
    int lo = lo0;
    int hi = hi0;
    
    if ( hi0 > lo0) {
        /* Arbitrarily establishing partition element as the midpoint of
         * the array.
         */
        int mid = ( lo0 + hi0 ) / 2;
        
        // loop through the array until indices cross
        while ( lo <= hi ) {
            /* find the first element that is greater than or equal to
             * the partition element starting from the left Index.
             */
            while (( lo < hi0 ) && ( [a compare:lo to:mid] < 0 )) {
                ++lo;
            }
            
            /* find an element that is smaller than or equal to
             * the partition element starting from the right Index.
             */
            while (( hi > lo0 ) && ( [a compare:hi to:mid] > 0 )) {
                --hi;
            }
            
            // if the indexes have not crossed, swap
            if ( lo <= hi ) {
                if (lo!=hi) {
                    [a swap:lo with:hi];
                    // keep mid pointing to the middle key value,
                    // not the middle position
                    if (lo==mid) {
                        mid=hi;
                    } else if (hi==mid) {
                        mid=lo;
                    }
                }
                ++lo;
                --hi;
            }
        }
        
        /* If the right index has not reached the left side of array
         * must now sort the left partition.
         */
        if ( lo0 < hi )
            XPQuickSort( a, lo0, hi );
        
        /* If the left index has not reached the right side of array
         * must now sort the right partition.
         */
        if ( lo < hi0 )
            XPQuickSort( a, lo, hi0 );
    }
}