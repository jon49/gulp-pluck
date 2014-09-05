fs = require 'fs'
es = require 'event-stream'
should = require 'should'

require 'mocha'

delete require.cache[require.resolve '../']

gutil = require 'gulp-util'
pluck = require '../index.js'

describe 'gulp-pluck', -> ``it``

   srcFile1 = new gutil.File(
      path: 'test/fixtures/test.txt'
      cwd: 'text/'
      base: 'test/fixtures'
      contents: fs.readFileSync 'test/fixtures/test.txt'
   )

   srcFile2 = new gutil.File(
      path: 'test/fixtures/test.txt'
      cwd: 'text/'
      base: 'test/fixtures'
      contents: fs.readFileSync 'test/fixtures/test.txt'
   )

   .. 'should produce expected file data property as array of objects', (done) !->

      srcFile1.data = {some: 'data'}
      srcFile2.data = {some: 'more data'}

      stream = pluck!

      stream.on 'error', (err) !->
         should.exist err
         done err

      stream.on 'data', (newFile) !->
         should.exist newFile.data
         newFile.data.should.eql [{some: 'data'}, {some: 'more data'}]
         done!

      stream.write srcFile1
      stream.write srcFile2
      stream.end!

   .. 'should be able to write new file name and pluck a different property name' (done) !->

      srcFile1.meta = {some: 'data'}
      srcFile2.meta = {some: 'more data'}

      stream = pluck 'meta', 'new-file-name.txt'

      stream.on 'error', (err) !->
         should.exist err
         done err

      stream.on 'data', (newFile) !->
         newFile.meta.should.eql [{some: 'data'}, {some: 'more data'}]
         newFile.path.should.equal 'test/fixtures/new-file-name.txt'
         done!

      stream.write srcFile1
      stream.write srcFile2
      stream.end!

   .. 'should work with a single file' (done) !->

      srcFile1.meta = {some: 'data'}

      stream = pluck 'meta', 'new-file-name.txt'

      stream.on 'error', (err) !->
         should.exist err
         done err

      stream.on 'data', (newFile) !->
         newFile.meta.should.eql [{some: 'data'}]
         newFile.path.should.equal 'test/fixtures/new-file-name.txt'
         done!

      stream.write srcFile1
      stream.end!
