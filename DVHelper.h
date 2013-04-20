//
//  DVHelper
//
//  Created by PHILIP LODEN on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRPNibBasedTableViewCell.h"
#import <CoreData/CoreData.h>

#define invokeSupersequent(...) \
([self getImplementationOf:_cmd \
after:impOfCallingMethod(self, _cmd)]) \
(self, _cmd, ##__VA_ARGS__)

#define invokeSupersequentNoParameters() \
([self getImplementationOf:_cmd \
after:impOfCallingMethod(self, _cmd)]) \
(self, _cmd)

IMP impOfCallingMethod(id lookupObject, SEL selector);

@interface NSObject (SupersequentImplementation)

- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip;

@end

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

@interface NSString (DVHelper)

- (id)JSONValue;
- (NSString *)DV_stringByPercentEncodingUsingEncoding:(NSStringEncoding)encoding;

@end

@interface NSArray (DVHelper)

- (NSMutableArray *)DV_sortedArrayUsingKey:(NSString *)aKey ascending:(BOOL)ascending;
  
@end
  
@interface UILabel (DVHelper)

- (void)DV_sizeToFitVerticallyConstrainedToHeight:(CGFloat)aHeight;

@end
  
@interface UINavigationController (DVHelper)

- (void)DV_pushViewControllerFadeIn:(UIViewController *)viewController;

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
+ (void)raiseVirtualMethodCalledException;
+ (void)setContentWidth:(UIScrollView *)aScrollView width:(CGFloat)aWidth;
+ (void)scaleImageView:(UIImageView *)imageView image:(UIImage *)image maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
+ (CFDictionaryRef)CFDictionaryWithObjectsAndKeys:(NSArray *)objects keys:(NSArray *)keys;
+ (NSArray *)fetchResultsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate managedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetchLocalResultsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate managedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)isiPhone5;

@end
