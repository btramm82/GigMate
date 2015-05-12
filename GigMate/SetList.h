//
//  SetList.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 5/12/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gigs, Song;

@interface SetList : NSManagedObject

@property (nonatomic, retain) NSString * setName;
@property (nonatomic, retain) NSSet *gig;
@property (nonatomic, retain) NSMutableOrderedSet *songs;
@end

@interface SetList (CoreDataGeneratedAccessors)

- (void)addGigObject:(Gigs *)value;
- (void)removeGigObject:(Gigs *)value;
- (void)addGig:(NSSet *)values;
- (void)removeGig:(NSSet *)values;

- (void)insertObject:(Song *)value inSongsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSongsAtIndex:(NSUInteger)idx;
- (void)insertSongs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSongsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSongsAtIndex:(NSUInteger)idx withObject:(Song *)value;
- (void)replaceSongsAtIndexes:(NSIndexSet *)indexes withSongs:(NSArray *)values;
- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSOrderedSet *)values;
- (void)removeSongs:(NSOrderedSet *)values;
@end
