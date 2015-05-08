//
//  SetList.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 4/29/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gigs, Song;

@interface SetList : NSManagedObject

@property (nonatomic, retain) NSString * setName;
@property (nonatomic, retain) NSSet *gig;
@property (nonatomic, retain) NSMutableSet *songs;
@end

@interface SetList (CoreDataGeneratedAccessors)

- (void)addGigObject:(Gigs *)value;
- (void)removeGigObject:(Gigs *)value;
- (void)addGig:(NSSet *)values;
- (void)removeGig:(NSSet *)values;

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
