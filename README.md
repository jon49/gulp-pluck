# [gulp](https://github.com/wearefractal/gulp)-pluck

[Learn more about gulp.js, the streaming build system](http://gulpjs.com)

## Introduction

Gulp-pluck makes it so you can take a property from file and concatenate it into a single array/file. E.g.,

```javascript
file1.data = {name: 'george'};
file2.data = {name: 'suzy'};
```

Turns into:

```javascript
file1.data;
// => [ {name: 'george'}, {name: 'suzy'} ]
```

gulp-pluck takes two optional parameters:

`propName` which defaults to `data`. `propName` tells `gulp-pluck` which property to operate on.

`fileName` will give the file a new name. `fileName` defaults to the first file name to pass through the function.

## Usage

First, install `gulp-pluck` as a development dependency:

    npm install --save-dev gulp-data

Then, add it to your gulpfile.js:

```javascript
var gulp = require('gulp');
var data = require('gulp-data');
var pluck = require('gulp-pluck');
var frontMatter = require('gulp-front-matter');

gulp.task('front-matter-to-json', function(){
  return gulp.src('./posts/*.md')
  .pipe(frontMatter({property: 'meta'}))
  .pipe(data(function(file){
    file.meta.path = file.path;
    return file;
  }))
  .pipe(pluck('meta', 'posts-metadata.json'))
  .pipe(data(function(file){
    file.contents = new Buffer(JSON.stringify(file.meta))
  }))
  .pipe(gulp.dest('dist'))
})
```

The data flow would look something like this:

**file1:**

```markdown
---
title: There's still hope for hoverboards
date: October 21, 2015
---

I'll hover convert your old road car into a skyway flyer!
```

**file2:**

```markdown
---
title: Finish it
date: 2500
---

Through that last dark cloud is a dying star. And soon enough, Xibalbia will die.
And when it explodes, it will be reborn. You will bloom...and I will live.
```

`frontMatter` turns it into:

```javascript
file1.meta
// => {
// title: "There's still hope for hoverboards"
// date: "October 21, 2015"
// }
file2.meta 
// => {
// title: "Finish it"
// date: "2500"
// }
```

`data` adds the file path:

```javascript
file1.meta
// => {
// title: "There's still hope for hoverboards"
// date: "October 21, 2015"
// path: "/posts/2015-10-21-hoverboards.md"
// }
file2.meta 
// => {
// title: "Finish it"
// date: "2500"
// path: "/posts/2500-finish_it.md"
// }
```

`pluck` reduces it to a single file:

```javascript
file1.meta // file1.path => "/posts/posts-metadata.json"
// => [{
// title: "There's still hope for hoverboards"
// date: "October 21, 2015"
// path: "/posts/2015-10-21-hoverboards.md"
// },
// {
// title: "Finish it"
// date: "2500"
// path: "/posts/2500-finish_it.md"
// }]
```

`data` then throws the object into a `JSON`-style `string` in the `contents` property so it prints out as a `JSON` file.
