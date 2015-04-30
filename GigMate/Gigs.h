//
//  Gigs.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 4/29/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SetList;

@interface Gigs : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *setList;
@end

@interface Gigs (CoreDataGeneratedAccessors)

- (void)addSetListObject:(SetList *)value;
- (void)removeSetListObject:(SetList *)value;
- (void)addSetList:(NSSet *)values;
- (void)removeSetList:(NSSet *)values;

@end
