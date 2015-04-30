//
//  Song.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 4/29/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SetList;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * bpm;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSSet *songsInSet;
@end

@interface Song (CoreDataGeneratedAccessors)

- (void)addSongsInSetObject:(SetList *)value;
- (void)removeSongsInSetObject:(SetList *)value;
- (void)addSongsInSet:(NSSet *)values;
- (void)removeSongsInSet:(NSSet *)values;

@end
