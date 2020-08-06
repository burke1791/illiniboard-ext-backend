const path = require('path');

module.exports = {
  mode: 'production',
  target: 'node',
  entry: {
    rssPoll: './functions/server/illiniboardRSS.js',
    updateArticlesInDatabase: './functions/server/updateArticlesInDatabase.js',
    root: './functions/client/root.js',
    register: './functions/client/register.js'
  },
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: '[name].js',
    libraryTarget: 'commonjs2'
  },
  optimization: {
    minimize: false
  }
}