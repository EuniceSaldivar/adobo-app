//
//  AdoboClient.h
//  AdoboApp
//
//  Created by Eunice Saldivar on 7/21/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

extern NSString * const baseURLString;

@interface AdoboClient : AFHTTPSessionManager

+ (AdoboClient *)sharedClient;

- (void)postAdoboSupportWithParameters:(NSDictionary *)param
                             imageData:(NSData *)imageData
                               success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
