var gulp = require('gulp');
//var path = require('path');
var sass = require('gulp-sass');
var watch = require('gulp-watch');
var minifycss = require('gulp-clean-css');
var rename = require('gulp-rename');
var gzip = require('gulp-gzip');
//var browserSync = require('browser-sync');
//var reload      = browserSync.reload;
var livereload = require('gulp-livereload');

var gzip_options = {
    threshold: '1kb',
    gzipOptions: {
        level: 9
    }
};
var sassDir = './project/apps/'
/* Compile Our Sass */
gulp.task('sass', function() {
    return gulp.src(sassDir+'**/static/scss/*.scss')
        .pipe(sass())
       // .pipe(parsePath())
        .pipe(
            rename(function(path){
                path.dirname += "/../css";
            })
        )
        .pipe(gulp.dest(sassDir))
        .pipe(rename({suffix: '.min'}))
        .pipe(minifycss())
        .pipe(gulp.dest(sassDir))
        .pipe(gzip(gzip_options))
        .pipe(gulp.dest(sassDir))
        .pipe(livereload());
        //.pipe(livereload())
});

/* Watch Files For Changes */
gulp.task('watch', function() {
    livereload.listen(3000);
    //livereload.listen(10000);
    gulp.watch('**/static/scss/*.scss', ['sass']);
    /* Trigger a live reload on any Django template changes */
    //browserSync.init({
    //    notify: false,
    //    proxy: "localhost:8000"
    //});
    gulp.watch(['./**/*.{scss,css,html,py,js}'], livereload.changed);
    gulp.watch('**/templates/*').on('change', livereload.changed);
    livereload.reload();

});


gulp.task('default', ['sass', 'watch']);
