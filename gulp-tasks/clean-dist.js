var del = require('del');

function cleanDist(gulp, plugins) {
  return function() {
    return del([
      'www/**/*'
    ]);
  };
};
module.exports = cleanDist;
