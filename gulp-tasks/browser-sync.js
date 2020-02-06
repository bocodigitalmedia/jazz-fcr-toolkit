module.exports = function(gulp, plugins) {

  return function() {

    var browserSync = require('browser-sync');
    var reload = browserSync.reload;

    browserSync.init({
      browser: 'google chrome',
      server: {
        baseDir: ['.tmp','public']
      }
    });

    return gulp.watch([
      '.tmp/**/*.html',
      'public/images/**/*',
      '.tmp/js/*.js'
    ]).on('change', reload);
  };

};
