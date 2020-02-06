module.exports = function(gulp, plugins) {

  return function() {
    return gulp
      .src(['source/jade/**/*.jade'], { base: './source/jade' })
      .pipe(plugins.jade({ pretty: true }))
      .pipe(gulp.dest('.tmp'));
  };

};
