//
//  ViewController.m
//  CoreDataTutorial
//
//  Created by Aditya Deshmane on 03/06/15.
//  Copyright (c) 2015 Aditya Deshmane. All rights reserved.
//

#import "ViewController.h"

//STEP 1: Import framework header
#import <CoreData/CoreData.h>


#import "Contact.h"//step 6

@interface ViewController ()

//STEP 2: Declare 3 core data essential vars
@property (strong, nonatomic) NSManagedObjectContext        *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel          *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator  *persistentStoreCoordinator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //step 8
    [self addContacts];
    [self fetchContacts];
}



//STEP 3: Copy all following methods in pragmas "Core Data Stack & Core Data Save" as it is, these are common methods required work with core data.

#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel
{
    //1. Create only if nil
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    //2. Set schema file name ( .xcdatamodeld file)
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    
    //3. Initialize managedObjectModel with url
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    //1. Create only if nil
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    
    //2. Init with ManagedObjectModel
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //3. Create .sqlite file path url
    NSURL *documentDirPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirPath URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    //4. Add SQLLite as persistent store using .sqlite file url
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Failed to initialize persistent store");
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    //1. Create only if nil
    if (_managedObjectContext != nil)
        return _managedObjectContext;
    
    //2. Get store coordinator
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
        return nil;
    
    //3. Initialize managedObjectContext & set perstent store for managedObjectContext
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

#pragma mark - Core Data Save

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])//save only if there are changes by checking "hasChanges"
        {
            NSLog(@"Failed to save context data");
        }
    }
}

//STEP 4: Setup Schema using Model Editor Interface
//STEP 5: Create Contact class as subclass of NSManagedObject using Model Editor Interface
//STEP 6: #import "Contact.h"
//STEP 7: Copy methods addContacts and fetchContacts
//STEP 8: Call methods addContacts and then fetchContacts from viewDidLoad

#pragma mark - Add and Fetch Contacts

-(void)addContacts
{
    //1. Get managedObjectContext
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //2. Create Entity with name and context
    Contact *contact1 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Contact"
                         inManagedObjectContext:context];
    
    //3. Set attribute values
    contact1.name = @"aaaa";
    contact1.email = @"aaaa@aaaa.com";
    contact1.phoneNumber = [NSNumber numberWithInt:1111];
    
    Contact *contact2 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Contact"
                         inManagedObjectContext:context];
    
    contact2.name = @"bbbb";
    contact2.email = @"bbbb@bbbb.com";
    contact2.phoneNumber = [NSNumber numberWithInt:2222];
    
    Contact *contact3 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Contact"
                         inManagedObjectContext:context];
    
    contact3.name = @"cccc";
    contact3.email = @"cccc@cccc.com";
    contact3.phoneNumber = [NSNumber numberWithInt:3333];
    
    //4. Save attributes by saving context
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Failed to save: %@", [error localizedDescription]);
    }
}

-(void)fetchContacts
{
    //1. Get entity by using name and context
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:context];
    
    //2. Create fetch request by setting entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    //3. Fetch objects
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    //4. Print fetched objects
    for (Contact *contact in fetchedObjects)
    {
        NSLog(@"Name: %@", contact.name);
        NSLog(@"Email: %@", contact.email);
        NSLog(@"Phone: %@", contact.phoneNumber);
        NSLog(@"----------------------");
    }
}

//STEP 9: RUN ( Delete and Run, otherwise same contact will appear twice on second run )
//STEP 10: Check console for output

/*
 Expected output
 
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] Name: aaaa
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] Email: aaaa@aaaa.com
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] Phone: 1111
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] ----------------------
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] Name: bbbb
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] Email: bbbb@bbbb.com
 2015-06-03 02:01:41.443 CoreDataTutorial[2861:26823] Phone: 2222
 2015-06-03 02:01:41.444 CoreDataTutorial[2861:26823] ----------------------
 2015-06-03 02:01:41.444 CoreDataTutorial[2861:26823] Name: cccc
 2015-06-03 02:01:41.444 CoreDataTutorial[2861:26823] Email: cccc@cccc.com
 2015-06-03 02:01:41.444 CoreDataTutorial[2861:26823] Phone: 3333
 2015-06-03 02:01:41.444 CoreDataTutorial[2861:26823] ----------------------
 
 */


@end
