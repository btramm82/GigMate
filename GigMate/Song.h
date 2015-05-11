//
//  Song.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 5/11/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SetList;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * bpm;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSSet *setList;
@end

@interface Song (CoreDataGeneratedAccessors)

- (void)addSetListObject:(SetList *)value;
- (void)removeSetListObject:(SetList *)value;
- (void)addSetList:(NSSet *)values;
- (void)removeSetList:(NSSet *)values;

@end
