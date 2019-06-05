//
//  ASMoreView.m
//  ASChatViewKit
//
//  Created by Lifee on 2019/5/13.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASMoreView.h"
#define as_row  2
#define as_col  4
#define as_item_name_h 21
@interface ASMoreView ()
@property (nonatomic ,strong) UIScrollView * scrollView ;
@property (nonatomic ,strong) NSArray * allOpts ;
@property (nonatomic ,assign) CGRect rct  ;

@end

@implementation ASMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _rct = frame ;
        [self _globalSet];
    }
    return self ;
}
- (instancetype)init {
    if (self = [super init]) {
        _rct = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 215.f);
        [self _globalSet];
    }
    return self ;
}
- (void)itemClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(asMoreView:onClickType:)]) {
        [self.delegate asMoreView:self onClickType:btn.tag];
    }
}
- (void)_globalSet {
    _allOpts = [NSArray arrayWithObjects:
                @{@"image":@"ChatRomm_ToolPanel_Icon_Photo" ,
                  @"name":@"照片",
                  @"tag":@"0"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Video" ,
                  @"name":@"拍摄",
                  @"tag":@"1"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Videovoip" ,
                  @"name":@"视频通话",
                  @"tag":@"2"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Location" ,
                  @"name":@"位置",
                  @"tag":@"3"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Luckymoney" ,
                  @"name":@"红包",
                  @"tag":@"4"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Pay" ,
                  @"name":@"转账",
                  @"tag":@"5"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Voiceinput" ,
                  @"name":@"语音输入",
                  @"tag":@"6"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_MyFav" ,
                  @"name":@"收藏",
                  @"tag":@"7"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_FriendCard" ,
                  @"name":@"个人名片",
                  @"tag":@"8"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Files" ,
                  @"name":@"文件",
                  @"tag":@"9"
                  },
                @{@"image":@"ChatRomm_ToolPanel_Icon_Wallet" ,
                  @"name":@"卡券",
                  @"tag":@"10"
                  }, nil
                ];

    
//                @"ChatRomm_ToolPanel_Icon_Multitalk",
//                @"ChatRomm_ToolPanel_Icon_Voipvoice",
    
    
    UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rct.size.width, 0.5)];
    [topline setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [self addSubview:topline];
    
    NSInteger pages = _allOpts.count % (as_col * as_row) == 0 ? _allOpts.count / (as_col * as_row) :_allOpts.count / (as_col * as_row) + 1;

    [self.scrollView setContentSize:CGSizeMake(self.rct.size.width * pages, self.rct.size.height)];
    [self addSubview:self.scrollView];
    
    NSInteger imgIndex = 0 ;
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 25, 15, 25);
    CGFloat spacing_x = 25 ;
    CGFloat spacing_y = 15 ;
    CGFloat screen_w = [UIScreen mainScreen].bounds.size.width ;

    CGFloat item_w =( screen_w - insets.left - insets.right - (as_col - 1) * spacing_x ) / as_col ;
//    _as_more_height = insets.top + insets.bottom + (as_row - 1)  * spacing_y + as_row * (item_w + as_item_name_h);
    
    for (int i = 0 ; i < pages; i ++) {
        UIView * morePageView = [[UIView alloc]init];
        morePageView.frame = CGRectMake(self.rct.size.width * i, 0, self.rct.size.width, self.rct.size.height);
        morePageView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self.scrollView addSubview:morePageView];
        for (int j = 0 ; j < as_row * as_col; j ++) {
            if (imgIndex >= _allOpts.count) {
                break ;
            }
            NSDictionary * d = _allOpts[imgIndex];
            UIButton * itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(insets.left + j % as_col * (item_w + spacing_x), insets.top + j / as_col * (item_w + spacing_y + as_item_name_h), item_w, item_w)];
            [itemBtn setBackgroundImage:[UIImage imageNamed:@"ChatRomm_ToolPanel_Icon_Buttons"] forState:UIControlStateNormal];
            [itemBtn setImage:[UIImage imageNamed:d[@"image"]] forState:UIControlStateNormal];
            [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.tag = [d[@"tag"] integerValue];
            [morePageView addSubview:itemBtn];
            //
            UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(insets.left + j % as_col * (item_w + spacing_x), itemBtn.frame.origin.y + item_w, item_w, as_item_name_h)];
            lb.textColor = [UIColor lightGrayColor];
            lb.font = [UIFont systemFontOfSize:12];
            lb.text = d[@"name"];
            lb.textAlignment = NSTextAlignmentCenter ;
            [morePageView addSubview:lb];
            
            imgIndex ++ ;
            if ((j + 1)% (as_row * as_col) == 0) {
                //切换下一页
                break;
            }
        }
    }

}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.5, self.rct.size.width, self.rct.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO ;
        _scrollView.showsHorizontalScrollIndicator = NO ;
        _scrollView.scrollEnabled = YES ;
        _scrollView.pagingEnabled = YES ;
    }
    return _scrollView ;
}
@end
