//
//  OpenCVWrapper.h
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

- (UIImage *)adjustTemperature:(UIImage *)image temperature:(float)temperature;

@end

NS_ASSUME_NONNULL_END
