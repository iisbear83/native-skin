var React = require('react-native');
var {
  ActivityIndicatorIOS,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  Animated
  } = React;

var Constants = require('../constants');
var {
  BUTTON_NAMES
} = Constants;

// Uses the rectbutton styles
var styles = require('../utils').getStyles(require('./style/RectButtonStyles.json'));
var PLAY = "play";
var PAUSE = "pause";

var VideoViewPlayPause = React.createClass({
  propTypes: {
    icons: React.PropTypes.object,
    position: React.PropTypes.string,
    onPress: React.PropTypes.func,
    opacity: React.PropTypes.number,
    frameWidth: React.PropTypes.number,
    frameHeight: React.PropTypes.number,
    buttonWidth: React.PropTypes.number,
    buttonHeight: React.PropTypes.number,
    buttonColor: React.PropTypes.string,
    buttonStyle: React.PropTypes.object,
    fontSize: React.PropTypes.number,
    style:React.PropTypes.object,
    showButton: React.PropTypes.bool,
    playing: React.PropTypes.bool,
    rate: React.PropTypes.number,
    initialPlay: React.PropTypes.bool,
  },

  getInitialState: function() {
    return {
      play: {
        animationScale: new Animated.Value(1),
        animationOpacity: new Animated.Value(1)
      },
      pause: {
        animationScale: new Animated.Value(1),
        animationOpacity: new Animated.Value(0)
      },
      widget: {
        animationOpacity: new Animated.Value(1)
      },
      showInitialPlayAnimation: this.props.initialPlay,
      inAnimation: false
    };
  },

  componentDidMount: function () {
    if (this.state.showInitialPlayAnimation) {
      this.playPauseAction(PLAY);
    }
  },

  componentWillReceiveProps: function(nextProps) {
    if (!this.state.inAnimation) {
      if (nextProps.playing) {

      } else {

      }
    }
  },

  onPress: function() {
    if(this.props.showButton) {
      if (this.props.playing) {
        this.playPauseAction(PAUSE);
      }
      else {
        this.props.onPress(BUTTON_NAMES.PLAY_PAUSE);
        this.playPauseAction(PLAY);
      }
    } else {
      this.props.onPress(BUTTON_NAMES.RESET_AUTOHIDE);
    }
  },

  onAnimationCompleted: function() {
    this.setState({inAnimation: false});
  },

  // Animations for play/pause transition
  playPauseAction: function(name) {
    if(name == PLAY) {
      this.setState({inAnimation: true});
      this.state.play.animationScale.setValue(1);
      this.state.play.animationOpacity.setValue(1);
      Animated.parallel([
        Animated.timing(this.state.play.animationOpacity, {
          toValue: 0
        }),
        Animated.timing(this.state.play.animationScale, {
          toValue: 2
        }),
        Animated.timing(this.state.pause.animationOpacity, {
          toValue: 1,
          duration: 100,
          delay: 1200
        })
      ]).start(this.onAnimationCompleted);
    }
    if(name == PAUSE) {
      this.state.pause.animationOpacity.setValue(0);
      this.state.play.animationOpacity.setValue(1);
      this.state.play.animationScale.setValue(1);
    }
  },

  _renderLoading: function(sizeStyle) {
    if(this.props.isLoading) {
      return (
        <Animated.View style={[styles.buttonArea, styles.loading, sizeStyle, {position: 'absolute'}]}>
          <ActivityIndicatorIOS
            animating={true}
            size="large">
          </ActivityIndicatorIOS>
        </Animated.View>);
    }
  },

  _renderButton(name) {
    var fontStyle = {fontSize: this.props.fontSize, fontFamily: this.props.icons[name].fontFamily};

    var opacity = {opacity: this.state[name].animationOpacity};
    var animate = {transform: [{scale: this.state[name].animationScale}]};
    var buttonColor = {color: this.props.buttonColor == null? "white": this.props.buttonColor};

    var size = {position: 'absolute'};

    return (
      <Animated.Text
        style={[styles.buttonTextStyle, fontStyle, buttonColor, this.props.buttonStyle, animate, opacity, size]}>
        {this.props.icons[name].icon}
      </Animated.Text>
    );
  },

  // Gets the play button based on the current config settings
  render: function() {
    if(this.props.style != null) {
      positionStyle = this.props.style;
    }
    else if (this.props.position == "center") {
      var topOffset = Math.round((this.props.frameHeight - this.props.buttonHeight) * 0.5);
      var leftOffset = Math.round((this.props.frameWidth - this.props.buttonWidth) * 0.5);

      positionStyle = {
        position: 'absolute', top: topOffset, left: leftOffset
      };
    } else {
      positionStyle = styles[this.props.position];
    }
    var sizeStyle = {width: this.props.buttonWidth, height: this.props.buttonHeight};
    var opacity = {opacity: this.state.widget.animationOpacity};

    var playButton = this._renderButton(PLAY);
    var pauseButton = this._renderButton(PAUSE);
    var loading = this._renderLoading(sizeStyle);

    if(this.props.showButton) {
      Animated.timing(this.state.widget.animationOpacity, {
        toValue: 1,
        duration: 400
      }).start();
    }
    else {
      Animated.timing(this.state.widget.animationOpacity, {
        toValue: 0,
        duration: 400
      }).start();
    }
    return (
      <TouchableHighlight
        onPress={() => this.onPress()}
        style={[positionStyle]}
        underlayColor="transparent"
        activeOpacity={this.props.opacity}>
        <View>
          {loading}
          <Animated.View style={[styles.buttonArea, sizeStyle, opacity, {position: 'absolute'}]}>
            {playButton}
            {pauseButton}
          </Animated.View>
        </View>
      </TouchableHighlight>
    );
  }
});

module.exports = VideoViewPlayPause;