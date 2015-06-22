var React = require('react-native');

var styles = React.StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  label: {
    textAlign: 'center',
    color: 'white',
    fontSize: 16,
    margin: 10,
    padding: 6,
    fontFamily: 'AvenirNext-DemiBold',
  },
  placeholder: {
    flex: 1,
  },
  button: {
    backgroundColor: '#F9F4F6',
    padding: 6,
    margin: 10,
    borderRadius: 5,
  },
  buttonText: {
    textAlign: 'center',
    color: '#030303',
    fontSize: 16,
    fontFamily: 'AvenirNext-DemiBold',
  },
});

module.exports = styles;

