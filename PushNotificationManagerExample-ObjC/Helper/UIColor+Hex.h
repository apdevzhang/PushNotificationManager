#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+(UIColor*)transformColorToHex:(NSString*)colorString;

+ (UIColor *)transformColorToHex:(NSString *)color alpha:(CGFloat)alpha;
@end
