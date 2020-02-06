var del = require('del');
var PWD = process.env.PWD;
var version = require(PWD + '/package.json').version;

module.exports = function (gulp, plugins) {

  return function (done) {

    var zipFolder = 'v' + version;
    var zipFile = 'v' + version + '.zip';

    gulp
      .src('zipTmp/**/**')
      .pipe(plugins.zip(zipFile))
      .pipe(gulp.dest('./'))
      .on('end', function () {
        del.sync(['./zipTmp']);
        done();
      });
  };
};
