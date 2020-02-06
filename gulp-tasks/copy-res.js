function copyRes(gulp, plugins) {
  return function copyFiles() {
    return gulp.src('resources/**/*')
      .pipe(gulp.dest('zipTmp/resources'));
  };
};
module.exports = copyRes;
