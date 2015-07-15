//
//  ViewController.m
//  AdoboApp
//
//  Created by Eunice Saldivar on 7/14/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    //[self addLayerShadow];
    
    signatureView= [[PJRSignatureView alloc] initWithFrame:CGRectMake(7, 457, 487, 225)];
    [signatureView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:signatureView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKey)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKey {
    [self.view endEditing:YES];
}
/*
-(void)addLayerShadow{
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:detailView.bounds];
    detailView.layer.masksToBounds = NO;
    detailView.layer.shadowColor = [UIColor blackColor].CGColor;
    detailView.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    detailView.layer.shadowOpacity = 0.5f;
    detailView.layer.shadowPath = shadowPath.CGPath;
    
}
*/

-(IBAction)clearSig:(id)sender{
    
    self.name.text = @"";
    self.age.text = @"";
    self.email.text = @"";
    self.num.text = @"";
    [signatureView clearSignature];
    
}

-(IBAction)doneSig:(id)sender{
    
    NSData *signatureData = UIImagePNGRepresentation([signatureView getSignatureImage]);
    UIImage * img = [UIImage imageWithData:signatureData];
    //NSLog(@"img size: %lu",(unsigned long)[signatureData length]);
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 30*30;
    
    while ([signatureData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        signatureData = UIImageJPEGRepresentation(img, compression);
    }
    //NSLog(@"compressed img size: %lu",(unsigned long)[signatureData length]);
    UIImage * compressedImg = [UIImage imageWithData:signatureData];
    // UIImageWriteToSavedPhotosAlbum(compressedImg, self, nil, nil);
    
    
    NSString *jsonName = self.name.text;
    NSString *jsonEmail = self.email.text;
    NSInteger age = [self.age.text integerValue];
    CGFloat num = [self.num.text floatValue];
    NSString *jsonAge = self.age.text;
    NSString *jsonNum = self.num.text;
    
    
    if (self.name.text.length == 0 || self.age.text.length == 0 || self.email.text.length == 0 || self.num.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"Incomplete fields. All fields are required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
    }
    else if ([signatureData length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"No signature found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if (self.age.text.length > 2){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"The age may not be greater than 2 characters." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if (!age){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"Invalid Age input." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
        
    else if (!num) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"Invalid Contact Number input." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    else if (self.num.text.length != 11) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"Contact Number should have at least 11 digits." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://gift.jumpdigital.asia"]];
        //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        NSData *imageData = UIImagePNGRepresentation(compressedImg);
        NSDictionary *param = @{@"name" : jsonName, @"age" : jsonAge, @"email" : jsonEmail, @"contact_number" : jsonNum};
        [manager POST:@"/adobo-signature-api/registrants"
           parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               //[formData appendPartWithFileURL:filePath name:@"image" error:nil];
               [formData appendPartWithFileData:imageData name:@"signature" fileName:@"signature.jpg" mimeType:@"image/jpeg"];
            
           }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Success: %@", responseObject);
     
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                      message:@"Thank you for supporting the #AdoboMovement." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                  [alertView show];
                  self.name.text = @"";
                  self.age.text = @"";
                  self.email.text = @"";
                  self.num.text = @"";
                  [signatureView clearSignature];
        
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                      message:[NSString stringWithFormat:@"%@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                  [alertView show];
              }
         ];
        
       
    }
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortrait);
    }
    else
    {
        return YES;
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
