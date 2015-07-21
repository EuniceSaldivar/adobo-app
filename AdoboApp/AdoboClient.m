//
//  AdoboClient.m
//  AdoboApp
//
//  Created by Eunice Saldivar on 7/21/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import "AdoboClient.h"

NSString * const baseURLString = @"http://gift.jumpdigital.asia";

@implementation AdoboClient

+ (AdoboClient *)sharedClient {
    static AdoboClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)postAdoboSupportWithParameters:(NSDictionary *)param
                             imageData:(NSData *)imageData
                               success:(void (^)(NSURLSessionDataTask *, id))success
                               failure:(void (^)(NSURLSessionDataTask *, NSError *error))failure{
    NSString* path = [NSString stringWithFormat:@"%@/",
                      baseURLString];
    [self POST:path parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:imageData name:@"signature" fileName:@"signature.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

}
@end