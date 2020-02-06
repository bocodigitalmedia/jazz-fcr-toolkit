function copyBuild(gulp, plugins) {
  return function copyFiles() {
    return gulp.src('www/**/*')
      .pipe(gulp.dest('zipTmp'));
  };
};
module.exports = copyBuild;
