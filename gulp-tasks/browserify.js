/**
 * Recipe for bundling js files using commonjs format with Browserify.
 *
 * Sources:
 * https://github.com/substack/node-browserify#usage
 * https://github.com/gulpjs/gulp/blob/master/docs/recipes/fast-browserify-builds-with-watchify.md
 */

'use strict';

var watchify = require('watchify');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var assign = require('lodash').assign;

function bundler(gulp, plugins) {

  var options = {
    entries: ['./source/coffee/app.coffee'],
    transform: ['coffeeify'],
    extensions: ['.coffee'],
    debug: true
  };
  var opts = assign({}, watchify.args, options);
  var b = watchify(browserify(opts));

  // Run the bundle on any dependency update.
  b.on('update', bundle);

  // Output build logs to terminal.
  b.on('log', plugins.util.log);

  function bundle() {
    return b.bundle()
      // log errors if they happen
      .on('error', plugins.util.log.bind(plugins.util, 'Browserify Error'))
      .pipe(source('app.bundle.js'))
      // optional, remove if you don't need to buffer file contents
      .pipe(buffer())
      // loads map from browserify file
      .pipe(plugins.sourcemaps.init({loadMaps: true}))
      // Note for devs: Add any transformation tasks to the pipeline here.

      // Will write .map file to the destination path.
      .pipe(plugins.sourcemaps.write('./'))
      .pipe(gulp.dest('./.tmp/js'));
  }

  return bundle;
};

module.exports = bundler;
