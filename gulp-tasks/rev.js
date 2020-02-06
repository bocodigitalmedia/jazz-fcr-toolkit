module.exports = function(gulp, plugins) {

  var rev = require('gulp-rev-append');

  return function() {
    return gulp
      .src('www/index.html')
      .pipe(rev())
      .pipe(gulp.dest('www'));
  };

};