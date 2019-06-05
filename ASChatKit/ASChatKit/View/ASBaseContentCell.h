//
//  ASBaseContentCell.h
//  NewAS
//
//  Created by Lifee on 2019/5/16.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMessageProtocol.h"

@interface ASBaseContentCell : UITableViewCell
@property (nonatomic ,strong) id <ASMessageProtocol> message  ;
@property (nonatomic ,strong) UIImageView * bubble ;
@property (nonatomic ,strong) UIImageView * avatar ;
@end


