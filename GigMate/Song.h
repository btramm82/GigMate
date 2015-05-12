//
//  Song.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 5/12/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SetList;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * bpm;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSOrderedSet *setList;
@end

@interface Song (CoreDataGeneratedAccessors)

- (void)insertObject:(SetList *)value inSetListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSetListAtIndex:(NSUInteger)idx;
- (void)insertSetList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSetListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSetListAtIndex:(NSUInteger)idx withObject:(SetList *)value;
- (void)replaceSetListAtIndexes:(NSIndexSet *)indexes withSetList:(NSArray *)values;
- (void)addSetListObject:(SetList *)value;
- (void)removeSetListObject:(SetList *)value;
- (void)addSetList:(NSOrderedSet *)values;
- (void)removeSetList:(NSOrderedSet *)values;
@end
