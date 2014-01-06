//
//  DDScanBarcodeViewController.m
//  DoubleDemo
//
//  Created by YoonBong Kim on 2014. 1. 6..
//  Copyright (c) 2014년 YoonBong Kim. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DDScanBarcodeViewController.h"

@interface DDScanBarcodeViewController ()  <AVCaptureMetadataOutputObjectsDelegate> {
    
    AVCaptureSession *_session;
}

@end

@implementation DDScanBarcodeViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)loadView
{
    [super loadView];

    [self initSession];
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(onClose)];
    
    self.navigationItem.leftBarButtonItem = closeBarButtonItem;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![_session isRunning]) {
        [_session startRunning];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    
}


- (void)initSession
{
    _session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (error) {
        
        NSLog(@"capture device input error : %@", error);
        
        return;
    }
    
    [_session addInput:input];
    
    
    AVCaptureMetadataOutput *metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_session addOutput:metaDataOutput];
    [metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];
    
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    previewLayer.frame = self.view.layer.bounds;
    
    [self.view.layer addSublayer:previewLayer];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIButton selector

- (void)onClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - AVCaptureMetadataOutput delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"read objects : %@", metadataObjects);
    
    for (AVMetadataObject *metadata in metadataObjects) {
        
        AVMetadataMachineReadableCodeObject *object = (AVMetadataMachineReadableCodeObject *)metadata;
        
        NSLog(@"object.type : %@, object.stringValue : %@", object.type, object.stringValue);
    }
}

@end
