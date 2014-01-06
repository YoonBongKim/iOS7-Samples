//
//  DDMainViewController.m
//  DoubleDemo
//
//  Created by YoonBong Kim on 2014. 1. 6..
//  Copyright (c) 2014년 YoonBong Kim. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "DDMainViewController.h"
#import "DDMediaPlayerViewController.h"
#import "DDScanBarcodeViewController.h"

@interface DDMainViewController ()  <MFMessageComposeViewControllerDelegate>    {
    
    MPVolumeView *_volumeView;
}

@end

@implementation DDMainViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    [super loadView];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake(10.0f, 50.0f, 300.0f, 44.0f);
    
    [sendButton setTitle:@"1. Message with Data" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onSMS) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendButton];
    
    
    UIButton *volumeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    volumeButton.frame = CGRectMake(10.0f, 120.0f, 300.0f, 44.0f);
    
    [volumeButton setTitle:@"2. Media Player with AirPlay" forState:UIControlStateNormal];
    [volumeButton addTarget:self action:@selector(onVolume) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:volumeButton];
    
    
    UIButton *barcodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    barcodeButton.frame = CGRectMake(10.0f, 190.0f, 300.0f, 44.0f);
    
    [barcodeButton setTitle:@"3. Scan Barcode" forState:UIControlStateNormal];
    [barcodeButton addTarget:self action:@selector(onScan) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:barcodeButton];
    
    
    _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10.0f, 300.0f, 300.0f, 20.0f)];
    
    [self.view addSubview:_volumeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wirelessRoutesAvailableNotification:) name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wirelessRoutesActiveNotification:) name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIButton selector

- (void)onSMS
{
    if ([MFMessageComposeViewController canSendAttachments]) {
        
        MFMessageComposeViewController *composer = [[MFMessageComposeViewController alloc] init];
        
        NSString *testString = @"lskdfjlksdjflksjdfklsjdflkjsldfjslkdfjslkdjflksjdflksjdflk";
        NSData *data = [testString dataUsingEncoding:NSUTF8StringEncoding];
        
        BOOL canAttach = [composer addAttachmentData:data typeIdentifier:(NSString *)kUTTypeUTF8PlainText filename:@"TEST.txt"];
        
        if (canAttach) {
            
        }
        else    {
            
        }
        
        [self presentViewController:composer animated:YES completion:nil];
    }
}


- (void)onVolume
{
    
    
}


- (void)onScan
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        DDScanBarcodeViewController *scanBarCodeViewCntrlr = [[DDScanBarcodeViewController alloc] init];
        UINavigationController *navigationCntrlr = [[UINavigationController alloc] initWithRootViewController:scanBarCodeViewCntrlr];
        
        [self presentViewController:navigationCntrlr animated:YES completion:nil];
    }
}


#pragma mark - MFMessageComposeViewController delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            
            break;
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultFailed:
            
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NSNotification selector

- (void)wirelessRoutesAvailableNotification:(NSNotification *)noti
{
    MPVolumeView *view = (MPVolumeView *)noti.object;
    
    view.hidden = (view.wirelessRoutesAvailable)? NO : YES;
}


- (void)wirelessRoutesActiveNotification:(NSNotification *)noti
{
    MPVolumeView *view = (MPVolumeView *)noti.object;
    
    view.showsVolumeSlider = (view.isWirelessRouteActive)? YES : NO;
    
}

@end
