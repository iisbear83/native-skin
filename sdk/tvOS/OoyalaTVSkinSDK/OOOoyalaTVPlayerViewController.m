//
//  OOOoyalaTVPlayerViewController.m
//  OoyalaTVSkinSDK
//
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

#import "OOOoyalaTVPlayerViewController.h"
#import "OOOoyalaTVConstants.h"
#import "OOOoyalaTVGradientView.h"
#import "OOOoyalaTVButton.h"
#import "OOOoyalaTVLabel.h"
#import "OOOoyalaTVBottomBars.h"
#import <OoyalaTVSDK/OOOoyalaPlayer.h>

#define SEEK_STEP 10

@interface OOOoyalaTVPlayerViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UITapGestureRecognizer *tapForwardGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapBackwardGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapPlayPauseGesture;

@property (nonatomic, strong) OOOoyalaTVLabel *durationLabel;
@property (nonatomic, strong) OOOoyalaTVLabel *playheadLabel;
@property (nonatomic, strong) OOOoyalaTVButton *playPauseButton;
@property (nonatomic, strong) OOOoyalaTVBottomBars *bottomBars;
@property (nonatomic, strong) OOOoyalaTVGradientView *progressBarBackground;
@property (nonatomic) CGFloat lastTriggerTime;

@end

@implementation OOOoyalaTVPlayerViewController

#pragma mark lifecyle methods

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear: animated];

  [self setupViewController];
  [self addGestures];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self removeGestures];
}

- (void)dealloc {
  [self removeObservers];
}

#pragma mark private helper functions
- (void)addGestures {
  self.tapForwardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seek:)];
  self.tapForwardGesture.allowedPressTypes = @[@(UIPressTypeRightArrow)];

  self.tapBackwardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seek:)];
  self.tapBackwardGesture.allowedPressTypes = @[@(UIPressTypeLeftArrow)];

  self.tapPlayPauseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePlay:)];
  self.tapPlayPauseGesture.allowedPressTypes = @[@(UIPressTypePlayPause), @(UIPressTypeSelect)];

  [self.view addGestureRecognizer:self.tapForwardGesture];
  [self.view addGestureRecognizer:self.tapBackwardGesture];
  [self.view addGestureRecognizer:self.tapPlayPauseGesture];
}

- (void)removeGestures {
  [self.view removeGestureRecognizer:self.tapForwardGesture];
  [self.view addGestureRecognizer:self.tapBackwardGesture];
  [self.view removeGestureRecognizer:self.tapPlayPauseGesture];
}

- (void)setupUI {
  [self setupProgessBackground];
  [self setupPlayPauseButton];
  [self setupBars];
  [self setupLabels];
  self.progressBarBackground.hidden = !self.playbackControlsEnabled;
}

- (void)setupProgessBackground {
  self.progressBarBackground = [[OOOoyalaTVGradientView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - bottomDistance * 2, self.view.bounds.size.width, bottomDistance * 2)];
  
  [self.view addSubview:self.progressBarBackground];
}

- (void)setupPlayPauseButton {
  // frame
  self.playPauseButton = [[OOOoyalaTVButton alloc] initWithFrame:CGRectMake(headDistance, self.progressBarBackground.bounds.size.height - playPauseButtonHeight - 38, headDistance, playPauseButtonHeight)];
                         [self.playPauseButton addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];
  
  // icon
  [self.playPauseButton changePlayingState:[self.player isPlaying]];
  
  // add to view
  [self.progressBarBackground addSubview:self.playPauseButton];
}

- (void)setupBars {
  self.bottomBars = [[OOOoyalaTVBottomBars alloc] initWithBackground:self.progressBarBackground];
  
  [self.progressBarBackground addSubview:self.bottomBars];
}

- (void)setupBar:(UIView *)bar
           color:(UIColor *)color {
  bar.backgroundColor = color;
  bar.layer.cornerRadius = barCornerRadius;
  
  [self.progressBarBackground addSubview:bar];
}

- (void)setupLabels {
  self.playheadLabel = [[OOOoyalaTVLabel alloc] initWithFrame:CGRectMake(playheadLabelX, self.progressBarBackground.bounds.size.height - bottomDistance - labelHeight, labelWidth, labelHeight)
                                                         time:self.player.playheadTime];
  self.durationLabel = [[OOOoyalaTVLabel alloc] initWithFrame:CGRectMake(self.progressBarBackground.bounds.size.width - headDistance - labelWidth, self.progressBarBackground.bounds.size.height - bottomDistance - labelHeight, labelWidth, labelHeight)
                                                         time:self.player.duration];

  [self.progressBarBackground addSubview:self.playheadLabel];
  [self.progressBarBackground addSubview:self.durationLabel];
}

#pragma mark property setters
- (void)setPlayer:(OOOoyalaPlayer *)player {
  [self removeObservers];
  _player = player;
  if (_player) {
    [self setupViewController];
  }
  [self addObservers];
}

- (void)setPlaybackControlsEnabled:(BOOL)playbackControlsEnabled {
  _playbackControlsEnabled = playbackControlsEnabled;
  self.progressBarBackground.hidden = !playbackControlsEnabled;
}

- (UIActivityIndicatorView *)activityView {
  if (!_activityView) {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.hidesWhenStopped = YES;
  }
  return _activityView;
}

- (void)setupViewController {
  self.player.view.frame = self.view.bounds;
  [self.view addSubview:self.player.view];
  
  self.activityView.center = self.view.center;
  [self.view addSubview:self.activityView];
  
  self.lastTriggerTime = 0;
  [self setupUI];
}

- (void)addObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncUI) name:OOOoyalaPlayerStateChangedNotification object:self.player];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncUI) name:OOOoyalaPlayerTimeChangedNotification object:self.player];
}

- (void)removeObservers {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)syncUI {
  switch (self.player.state) {
    case OOOoyalaPlayerStateLoading:
      [self.activityView startAnimating];
      break;
    case OOOoyalaPlayerStateReady:
      break;
    case OOOoyalaPlayerStatePlaying:
      break;
    case OOOoyalaPlayerStatePaused:
      break;
    case OOOoyalaPlayerStateError:
      break;
    default:
      break;
  }
  
  if (self.player.state != OOOoyalaPlayerStateLoading) {
    [self.activityView stopAnimating];
  }
  
  [self updateTimeWithDuration:self.player.duration
                      playhead:self.player.playheadTime];
  
  [self.bottomBars updateBarBuffer:self.player.bufferedTime playhead:self.player.playheadTime duration: self.player.duration totalLength:(self.view.bounds.size.width - 388)];
}

- (void)updateTimeWithDuration:(CGFloat)duration playhead:(CGFloat)playhead {
  NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
  [dateformat setDateFormat:duration < 3600 ? @"mm:ss" : @"H:mm:ss"];
  self.playheadLabel.text = [NSString stringWithFormat:@"%@", [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:playhead]]];
  self.durationLabel.text = [NSString stringWithFormat:@"%@", [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:duration]]];
  
  [self.playPauseButton changePlayingState:[self.player isPlaying]];
  
  if (playhead - self.lastTriggerTime > hideBarInterval && playhead - self.lastTriggerTime < hideBarInterval + 2) {
    [self hideProgressBar];
  }
}

- (void)togglePlay:(id)sender {
  if ([self.player isPlaying]) {
    [self.player pause];
  } else {
    [self.player play];
  }
  
  [self showProgressBar];
  [self.playPauseButton changePlayingState:[self.player isPlaying]];
}

- (void)showProgressBar {
  self.lastTriggerTime = self.player.playheadTime;
  if (self.progressBarBackground.frame.origin.y == self.view.bounds.size.height) {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
      self.progressBarBackground.alpha = 1.0;
      
      CGRect frame = self.progressBarBackground.frame;
      frame.origin.y -= frame.size.height;
      self.progressBarBackground.frame = frame;
    } completion: nil];
  }
}

- (void)hideProgressBar {
  if (self.progressBarBackground.frame.origin.y < self.view.bounds.size.height) {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
      self.progressBarBackground.alpha = 0.0;
      
      CGRect frame = self.progressBarBackground.frame;
      frame.origin.y += frame.size.height;
      self.progressBarBackground.frame = frame;
    } completion: nil];
  }
}

- (void)seek:(UITapGestureRecognizer *)sender {
  if (!self.playbackControlsEnabled) {
    return;
  }

  NSTimeInterval seekTo = self.player.playheadTime;
  if (sender == self.tapForwardGesture) {
    seekTo += SEEK_STEP;
  } else if (sender == self.tapBackwardGesture) {
    seekTo -= SEEK_STEP;
  }
  [self.player seek:seekTo];
  [self showProgressBar];
}

- (UIView *)preferredFocusedView {
  return self.player.view;
}


@end
