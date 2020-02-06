/**
 * Recipe for compiling sass library into css.
 *
 * Note: gulp-sass is a wrapper for 'node-sass' which is a wrapper for
 * 'libsass'.  Consult those docs for additional information or issues.
 *
 * Sources:
 * https://github.com/dlmanning/gulp-sass
 * https://github.com/sass/node-sass
 * https://github.com/sass/libsass
 */

var reload = require('browser-sync').reload;

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
      .pipe(plugins.sourcemaps.write())
      .pipe(gulp.dest('.tmp/css'))
      .pipe(reload({
        stream: true
      }));
  };

};

module.exports = sass;
