/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';
 var React = require('react-native');
 var {
  View,
  StyleSheet
} = React;

var ProgressBar = require('./progressBar');
var ControlBar = require('./controlBar');
var AnimationExperimental = require('AnimationExperimental');
var DiscoveryPanel = require('./discoveryPanel');

var ICONS = require('./constants').ICONS;

var VideoView = React.createClass({
  getInitialState: function() {
    return {showControls:true};
  },

  propTypes: {
    showPlay: React.PropTypes.bool,
    playhead: React.PropTypes.number,
    buffered: React.PropTypes.number,
    duration: React.PropTypes.number,
    discovery: React.PropTypes.array,
    width: React.PropTypes.number,
    onPress: React.PropTypes.func,
    onScrub: React.PropTypes.func,
  },

  handlePress: function(name) {
    this.props.onPress(name);
  },

  handleScrub: function(value) {
    this.props.onScrub(value);
  },

  getDefaultProps: function() {
    return {showPlay: true, playhead: 0, buffered: 0, duration: 1};
  },

  toggleControlBar: function() {
    for (var ref in this.refs) {
      console.log("ref is",ref);
      AnimationExperimental.startAnimation({
        node: this.refs[ref],
        duration: 500,
        property: 'opacity',
        easing: 'easingInOutExpo',
        toValue: this.state.showControls ? 0 : 1,
      });
    }
    this.setState({showControls:!this.state.showControls});
  },

  handleTouchEnd: function(event) {
    this.toggleControlBar();
  },

  render: function() {
    var placeHolder;
    var progressBar;
    var controlBar;

    if (this.props.discovery) {
      placeHolder = (
        <DiscoveryPanel
          dataSource={this.props.discovery}>
        </DiscoveryPanel>);
    } else {
      placeHolder = (
        <View 
          style={styles.placeholder}
          onTouchEnd={(event) => this.handleTouchEnd(event)}>  
        </View>);
    }
    
    progressBar = (<ProgressBar ref='progressBar' 
      playhead={this.props.playhead} 
      duration={this.props.duration}
      width={this.props.width} 
      onScrub={(value)=>this.handleScrub(value)} />);

    controlBar = (<ControlBar 
      ref='controlBar' 
      showPlay={this.props.showPlay} 
      playhead={this.props.playhead} 
      duration={this.props.duration} 
      primaryActionButton = {this.props.showPlay? ICONS.PLAY: ICONS.PAUSE}
      onPress={(name) => this.handlePress(name)} />);
    
    return (
      <View style={styles.container}>
      {placeHolder}
      {progressBar}
      {controlBar}
      </View>
      );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
    backgroundColor: 'transparent',
  },
  placeholder : {
    flex: 1,
    alignItems: 'stretch',
    backgroundColor: 'transparent',
  },
});

module.exports = VideoView
