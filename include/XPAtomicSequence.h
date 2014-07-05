//
//  XPAtomicSequence.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPSequence.h>
#import <Panthro/XPValue.h>

/**
 * Interface representing a sequence of atomic values. This is often used to represent the
 * typed value of a node. In most cases the typed value of a node is a single atomic value,
 * so the class AtomicValue implements this interface.
 *
 * <p>An AtomicSequence is always represented as a GroundedValue: that is, the entire sequence
 * is in memory, making operations such as {@link #itemAt(int)} and {@link #getLength()} possible.</p>
 */

@protocol XPAtomicSequence <XPSequence>

- (XPValue *)head;

- (id <XPSequenceEnumeration>)enumerate;

- (XPValue *)itemAt:(NSUInteger)i;

- (NSUInteger)count;

@end
