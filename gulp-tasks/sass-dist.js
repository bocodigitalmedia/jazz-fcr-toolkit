function sass(gulp, plugins) {

  return function compileSass() {

    function swallowError(error) {
      console.error('Sass error: ', error.toString());
      this.emit('end');
    }

    return gulp.src('source/sass/main.sass')
      .pipe(plugins.sourcemaps.init())
      .pipe(plugins.sass({
        outputStyle: 'nested',
        precision: 10,
        includePaths: ['.']
      }))
      .on('error', swallowError)
      .pipe(plugins.postcss([
        require('autoprefixer')({browsers: ['last 2 versions']})
      ]))
      .pipe(gulp.dest('www/css'));
  };

};

module.exports = sass;
