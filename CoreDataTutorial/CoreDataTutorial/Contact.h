//
//  Contact.h
//  
//
//  Created by Aditya Deshmane on 03/06/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * phoneNumber;
@property (nonatomic, retain) NSString * email;

@end
