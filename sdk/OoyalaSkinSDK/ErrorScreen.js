
var React = require('react-native');

var {
  StyleSheet,
  Text,
  View
} = React;

var Utils = require('./utils');
var styles = Utils.getStyles(require('./style/errorScreenStyles.json'));

var ErrorScreen = React.createClass({
  propTypes: {
    error: React.PropTypes.object,
    localizableStrings: React.PropTypes.object,
    locale: React.PropTypes.string
  },

  getTitle: function() {
    var errorCode = -1;
    if (this.props.error && this.props.error.code) {
      errorCode = this.props.error.code;
    }
    var title = Utils.stringForErrorCode(errorCode);
    var localizedTitle = 
      Utils.localizedString(this.props.locale, title, this.props.localizableStrings);

    return (
      <Text style={styles.title}>
        {localizedTitle}
      </Text>);
  },

  getDescription: function () {
    if (this.props.error && this.props.error.description) {
      var localizedDescription = 
        Utils.localizedString(this.props.locale, this.props.error.description, this.props.localizableStrings);
      return (
        <Text style={styles.description}>
          {localizedDescription} 
        </Text>);
    }
    return null; 
  },

  render: function() {  
    var title = this.getTitle();
    var description = this.getDescription();

    return (
      <View style={styles.container}>
        {title}
        {description}
      </View>
    );
  },
});

module.exports = ErrorScreen;