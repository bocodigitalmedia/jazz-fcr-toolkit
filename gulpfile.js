var gulp = require('gulp');
var plugins = require('gulp-load-plugins')();
var exec = require('child_process').exec;

function getTask(task) {
  return require('./gulp-tasks/' + task)(gulp, plugins);
}

gulp.task('browserify', getTask('browserify'));
gulp.task('jade', getTask('jade'));
gulp.task('sass', getTask('sass'));
gulp.task('browser-sync', ['compile'], getTask('browser-sync'));

gulp.task('clean:dist', getTask('clean-dist'));

gulp.task('jade-dist', ['clean:dist'], getTask('jade-dist'));
gulp.task('sass-dist', ['clean:dist'], getTask('sass-dist'));
gulp.task('browserify-dist', ['clean:dist'], getTask('browserify-dist'));
gulp.task('copy:public', ['clean:dist'], getTask('copy-public'));
gulp.task('rev', ['jade-dist','sass-dist','browserify-dist'], getTask('rev'));

gulp.task('copy:config', getTask('copy-config'));
gulp.task('copy:res', getTask('copy-res'));
gulp.task('copy:build', ['build'], getTask('copy-build'));

gulp.task('zip',['copy:build','copy:res','copy:config'], getTask('zip'));
gulp.task('emulate',['build'],function(cb) {
  console.log('**** Building iOS Package and starting iOS Simulator ****');
  // exec('cordova emulate ios --target="iPhone-6s"',{maxBuffer: 1024 * 1024}, function(err, stdout, stderr) {
  exec('cordova emulate ios --target="iPad-Retina"',{maxBuffer: 1024 * 1024}, function(err, stdout, stderr) {
    if (err) {
      console.error(err);
      return;
    }
    cb();
  });
});


// Start local server.
gulp.task('serve', ['browser-sync'], function () {
  gulp.watch('source/jade/**/*.jade', ['jade']);
  gulp.watch('source/sass/**/*.{sass,scss}', ['sass']);
});

gulp.task('compile', ['jade', 'sass', 'browserify'] )
gulp.task('default', ['serve'] );
gulp.task('build', ['clean:dist','jade-dist','sass-dist','browserify-dist','copy:public','rev'] );
