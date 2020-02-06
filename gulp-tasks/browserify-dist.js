var browserify = require('browserify');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var assign = require('lodash').assign;

function bundler(gulp, plugins) {

  var options = {
    entries: ['./source/coffee/app.coffee'],
    transform: ['coffeeify'],
    extensions: ['.coffee'],
    debug: false
  };
  var b = browserify(options);

  // Output build logs to terminal.
  b.on('log', plugins.util.log);

  function bundle() {
    return b.bundle()
      .on('error', plugins.util.log.bind(plugins.util, 'Browserify Error'))
      .pipe(source('app.bundle.js'))
      .pipe(buffer())
      .pipe(gulp.dest('./www/js'));
  }

  return bundle;
};

module.exports = bundler;
