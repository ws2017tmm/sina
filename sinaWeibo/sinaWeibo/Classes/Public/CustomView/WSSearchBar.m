//
//  WSSearchBar.m
//  sinaWeibo
//
//  Created by XSUNT45 on 16/3/31.
//  Copyright © 2016年 XSUNT45. All rights reserved.
//

#import "WSSearchBar.h"

@interface WSSearchBar ()

{
    UIImageView *_searchIcon;//searchBar左边的图片
}

@end

@implementation WSSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //设置searchbar的一些基本属性
        self.font = [UIFont systemFontOfSize:12];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.placeholder = @"请输入搜索条件";
        self.background = [[UIImage imageNamed:@"searchbar_textfield_background"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        //搜索框左边的图片
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        _searchIcon.contentMode = UIViewContentModeCenter;
        
        //设置searchBar左边的图片
        self.leftView = _searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        //检测搜索框是否处于编辑状态
        [WSNotificationCenter addObserver:self selector:@selector(textFieldTextDidChanged) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
        //检测搜索框是否结束编辑状态
        [WSNotificationCenter addObserver:self selector:@selector(textFieldTextDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
    return self;
}

//处于编辑状态---更换图片
- (void)textFieldTextDidChanged {
    _searchIcon.image = [UIImage imageNamed:@"find_people"];
}

//结束编辑状态---更换图片
- (void)textFieldTextDidEndEditing {
    _searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
}

//创建searchBar
+ (WSSearchBar *)searchBar {
    return [[self alloc] init];
}

//设置子控件的尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _searchIcon.height = self.height;
    _searchIcon.width = _searchIcon.height;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
