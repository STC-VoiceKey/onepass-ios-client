//
//  OPUICorporateColorUtils.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#ifndef OPUICorporateColorUtils_h
#define OPUICorporateColorUtils_h

#define OPUICorporateDarkBlue   [UIColor colorWithRed:000.0/255.0 green:042.0/255.0 blue:066.0/255.0 alpha:1.0]
#define OPUICorporateColdWhite  [UIColor colorWithRed:240.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]
#define OPUICorporateTurquoise  [UIColor colorWithRed:000.0/255.0 green:154.0/255.0 blue:166.0/255.0 alpha:1.0]

//converters for color from hex RGB to UIColor
#define UIColorFromRGBCGColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0].CGColor;


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* OPUICorporateColorUtils_h */
