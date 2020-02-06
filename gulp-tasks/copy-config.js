function copyConfig(gulp, plugins) {
  return function copyFiles() {
    return gulp.src('config.xml')
      .pipe(gulp.dest('zipTmp'));
  };
};
module.exports = copyConfig;
