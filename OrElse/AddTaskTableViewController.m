//
//  AddTaskTableViewController.m
//  OrElse
//
//  Created by Hani Kazmi on 04/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "AddTaskTableViewController.h"
#import "Task.h"


@interface AddTaskTableViewController ()

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *taskTextField;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *datePickerToolbar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UITextField *notesTextField;

@end


@implementation AddTaskTableViewController

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        id delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate performSelector:@selector(managedObjectContext)]) {
            _managedObjectContext = [delegate managedObjectContext];
        }
    }
    
    return _managedObjectContext;
}

- (NSDateFormatter *)dateFormatter
{
    // Set the date style to display
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return _dateFormatter;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hookup datePicker to its textField
    self.dateTextField.text = [self.dateFormatter stringFromDate:[NSDate date]];
    [self.dateTextField setInputView:self.datePicker];
    [self.dateTextField setInputAccessoryView:self.datePickerToolbar];
}


#pragma mark - IBActions

- (IBAction)dissmissKeyboard:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)dissmissDatePicker:(UIBarButtonItem *)sender
{
    [self.dateTextField resignFirstResponder];
}

- (IBAction)updateDateTextField:(UIDatePicker *)sender
{
    self.dateTextField.text = [self.dateFormatter stringFromDate:[self.datePicker date]];
}

- (IBAction)addTask:(UIButton *)sender
{
    // Ensure the task field is not empty
    if ([self.taskTextField.text length]) {
        
        // Insert new task into model
        NSManagedObjectContext *context = self.managedObjectContext;
        Task *currentTask = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Task"
                             inManagedObjectContext:context];

        // Set the task's fields
        currentTask.name = self.taskTextField.text;
        currentTask.isCompleted = [NSNumber numberWithBool:NO];
        currentTask.date = [self.dateFormatter dateFromString:self.dateTextField.text];
        currentTask.notes = self.notesTextField.text;
        
        // Save model
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        // Return to previous view
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

@end
