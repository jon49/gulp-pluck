path = require 'path'
gutil = require 'gulp-util'
PluginError = gutil.PluginError
reduce = require 'stream-reduce'

module.exports = (propName, fileName) ->

   propName_ = propName or 'data'

   initializeFile = (file, prop) ->
      file_ = file.clone!           # clone first file 
      file_[prop] = [ file[prop] ]  # wrap property in array 
      file_.path =                  # change file name
         if fileName
         then path.join(file_.base, fileName)
         else file_.path
      file_

   appendProp = (appendTo, appendFrom, prop) ->
      appendTo[prop].push appendFrom[prop]
      appendTo

   pluck = (plucked, file) ->
      | file.isNull! =>    # skip empty file
         plucked
      | file.isStream! =>  # doh!
         @emit (
            'error'
            new PluginError 'gulp-pluck', 'Streaming not supported'
         )
      | plucked =>         # append new property value
         appendProp plucked, file, propName_
      | _ =>               # initialize plucked file
         initializeFile file, propName_

   reduce pluck, void
