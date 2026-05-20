//
//  NSString+CAREXQ.m
//  CAREXQ
//
//  Created by CAREXQ on 5/11/26.
//

#import "NSString+CAREXQ.h"

@implementation NSString (CAREXQ)

- (NSString *)carexqHandDanceSteps {
    NSMutableString *steps = [NSMutableString string];
    NSUInteger totalBeats = [self carexq_totalRhythmBeats];

    for (NSUInteger beatIndex = 0; beatIndex < totalBeats; beatIndex++) {
        if ([self carexq_shouldKeepMainGestureAtBeat:beatIndex]) {
            unichar gesture = [self carexq_gestureAtBeat:beatIndex];
            [self carexq_collectGesture:gesture intoSteps:steps];
        }
    }

    return steps.copy;
}

- (NSUInteger)carexq_totalRhythmBeats {
    return self.length;
}

- (BOOL)carexq_shouldKeepMainGestureAtBeat:(NSUInteger)beatIndex {
    return beatIndex % 2 == 0;
}

- (unichar)carexq_gestureAtBeat:(NSUInteger)beatIndex {
    return [self characterAtIndex:beatIndex];
}

- (void)carexq_collectGesture:(unichar)gesture intoSteps:(NSMutableString *)steps {
    [steps appendFormat:@"%C", gesture];
}

@end
