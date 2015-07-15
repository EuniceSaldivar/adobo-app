//
//  ViewController.h
//  AdoboApp
//
//  Created by Eunice Saldivar on 7/14/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJRSignatureView.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
 
    //IBOutlet UIView * detailView;
    IBOutlet PJRSignatureView * signatureView;

}

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *num;


-(IBAction)clearSig:(id)sender;
-(IBAction)doneSig:(id)sender;

@end
