//
//  DVHelper
//
//  Created by PHILIP LODEN on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (XCRHelper)

- (void)deselectSelectedRow;

@end

@interface NSDictionary (XCRHelper)

- (id)objectForKeyOrDefault:(id)aKey aDefault:(id)aDefault;
- (id)objectForKeyOrEmptyString:(id)aKey;
- (id)objectForKeyOrNil:(id)aKey;
- (NSInteger)intForKeyOrDefault:(id)aKey aDefault:(NSInteger)aDefault;
- (BOOL)boolForKeyOrDefault:(id)aKey aDefault:(BOOL)aDefault; 
- (id)objectForInt:(NSInteger)anInt;

@end

@interface NSMutableDictionary (XCRHelper)

- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey;

@end

@interface DVHelper : NSObject {
	
}

+ (void)shiftOriginX:(UIView *)aView x:(CGFloat)x;
+ (void)shiftOriginY:(UIView *)aView y:(CGFloat)y;
+ (void)setOriginX:(UIView *)aView x:(CGFloat)x;
+ (void)setOriginY:(UIView *)aView y:(CGFloat)y;
+ (void)setOrigin:(UIView *)aView origin:(CGPoint)origin;
+ (void)setWidth:(UIView *)aView width:(CGFloat)width;
+ (void)setHeight:(UIView *)aView height:(CGFloat)height;
+ (void)setSize:(UIView *)aView size:(CGSize)aSize;
+ (NSString *)base64Encoding:(NSData *)aData;
+ (void)showErrorAlertWithMessage:(NSString *)message;
+ (BOOL)isNilOrEmtpyString:(NSString *)aString;
+ (NSString *)stringOrDefault:(NSString *)aString defaultString:(NSString *)defaultString;
+ (UIView *)firstResponderForView:(UIView *)aView;
+ (id)getOrCreateTemplate:anEntityName
                  predicate:(NSPredicate *)aPredicate
                    context:(NSManagedObjectContext *)aContext
                didCreate:(BOOL*)didCreate
                createBlock:(id(^)())aCreateBlock;
+ (NSFetchedResultsController *)fetchedResultsController:(NSString *)anEntityName
                                               predicate:(NSPredicate *)aPredicate
                                          sortDescriptor:(NSSortDescriptor *)aSortDescriptor
                                                 context:(NSManagedObjectContext *)aContext;
/*
 Assumes nib name is same as class name.
 */
+ (id)loadObjectOfClassFromNib:(Class)aClass;
  
@end
