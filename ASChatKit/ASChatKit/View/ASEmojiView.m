//
//  ASEmojiView.m
//  ASChatViewKit
//
//  Created by Lifee on 2019/5/8.
//  Copyright © 2019年 ASWorld. All rights reserved.
//

#import "ASEmojiView.h"
#import "UIView+ASAddition.h"
#define as_col 7
#define as_row 3

#define ASDeleteEmojiButtonTag  888

@interface ASEmojiView()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView * scrollView ;
@property (nonatomic ,assign) CGRect rct  ;
@property (nonatomic ,strong) UIPageControl * pageControl ;
@property (nonatomic ,strong) UIButton * sendButton ;
@end

@implementation ASEmojiView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _rct = frame ;
        [self as_initView];
    }
    return self ;
}
- (instancetype)init {
    if (self = [super init]) {
        _rct = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 215.f);
        [self as_initView];
    }
    return self ;
}
- (void)as_initView {
    
    UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rct.size.width, 0.5)];
    [topline setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.5]];
    [self addSubview:topline];
    
    NSString * emojiPath = [[NSBundle mainBundle]pathForResource:@"asemoji" ofType:@"plist"];
    NSArray * emojis = [NSArray arrayWithContentsOfFile:emojiPath];
    //分页计算
    NSInteger pages = emojis.count % (as_col * as_row) == 0 ? emojis.count / (as_col * as_row) :emojis.count / (as_col * as_row) + 1;
    if (pages * as_row * as_col < emojis.count + pages) {
        pages ++ ;
    }

    //
    NSInteger imgIndex = 0 ;
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 0, 20);
    CGFloat spacing_x = 10 ;
    CGFloat spacing_y = 15 ;
    CGFloat emoji_w =(_rct.size.width - insets.left - insets.right - (as_col - 1) * spacing_x ) / as_col ;
    
    [self.scrollView setContentSize:CGSizeMake(self.rct.size.width * pages, self.rct.size.height)];
    self.pageControl.numberOfPages = pages ;
    _pageControl.frame = CGRectMake(0, 10 + as_row * emoji_w + spacing_y * (as_row - 1) , self.scrollView.width, 40);
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self addSubview:self.sendButton];
    
    for (int i = 0 ; i < pages; i ++) {
        UIView * emojiPageView = [[UIView alloc]init];
        emojiPageView.frame = CGRectMake(self.rct.size.width * i, 0, self.rct.size.width, self.rct.size.height);
        emojiPageView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self.scrollView addSubview:emojiPageView];
        for (int j = 0 ; j < as_row * as_col; j ++) {
            if (imgIndex > emojis.count) {
                break ;
            }
            UIButton * emojiBtn = [[UIButton alloc]initWithFrame:CGRectMake(insets.left + j % as_col * (emoji_w + spacing_x), insets.top + j / as_col * (emoji_w + spacing_y), emoji_w, emoji_w)];
            [emojiBtn.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:28.0]];
            //处理最后一个表情
            if ((j + 1)% (as_row * as_col) == 0 || imgIndex >= emojis.count) {
                [emojiBtn setBackgroundImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
                [emojiPageView addSubview:emojiBtn];
                emojiBtn.tag = ASDeleteEmojiButtonTag ;
                [emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
                //切换下一页
                break;
            }else {
                [emojiBtn setTitle:emojis[imgIndex] forState:UIControlStateNormal];
                [emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
                [emojiPageView addSubview:emojiBtn];
                imgIndex ++ ;
            }
        }
        
    }
    //
}

- (void)emojiClick:(UIButton *)btn {
    if (btn.tag == ASDeleteEmojiButtonTag) {
        if ([self.delegate respondsToSelector:@selector(asEmojiDelete:)]) {
            [self.delegate asEmojiDelete:self];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(asEmojiInput:emoji:)]) {
            [self.delegate asEmojiInput:self emoji:btn.currentTitle];
        }
    }
}
- (void)sendMessage{
    if ([self.delegate respondsToSelector:@selector(asEmojiSend:)]) {
        [self.delegate asEmojiSend:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width ;
    self.pageControl.currentPage = index ;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        _sendButton.height = 30 ;
        _sendButton.width = 54 ;
        _sendButton.right = self.scrollView.width - 20 ;
        _sendButton.centerY = self.pageControl.centerY ;

        _sendButton.layer.cornerRadius = 4 ;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:30/255.0 green:198/255.0 blue:34/255.0 alpha:1]];
        [_sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton ;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.5, self.rct.size.width, self.rct.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO ;
        _scrollView.showsHorizontalScrollIndicator = NO ;
        _scrollView.scrollEnabled = YES ;
        _scrollView.pagingEnabled = YES ;
        _scrollView.delegate = self ;
    }
    return _scrollView ;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES ;
    }
    return _pageControl ;
}
@end
