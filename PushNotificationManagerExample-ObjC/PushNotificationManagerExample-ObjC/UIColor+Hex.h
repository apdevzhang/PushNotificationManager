//
//  Created by BANYAN on 2016/11/7.
//  Copyright © 2016年 BANYAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+(UIColor*)transformColorToHex:(NSString*)colorString;

+ (UIColor *)transformColorToHex:(NSString *)color alpha:(CGFloat)alpha;
@end
