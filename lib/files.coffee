fs       = require "fs"
path     = require "path"

fsExtra  = require "fs.extra"
{check}  = require "validator"
request  = require "request"


# Fetch file from URL into specified path.
exports.fetchFromUrl = (url, path, callback) ->
  if !url or !path or !callback
    callback {code: "invalidArguments", message: "Mandatory arguments weren't specified"}
    return
  try
    check(url).isUrl() # check url for validity
    req = request url, (err, response, body) ->
      if err or response.statusCode != 200
        callback {code: "fileNotFound", message: "File wasn't found on URL '#{url}'"}  # error callback
    req.on "end", () ->
      callback undefined, path # success callback
    req.pipe fs.createWriteStream(path)
  catch error
    callback {code: "invalidURL", message: "'#{url}' is invalid file URL"}  # error callback

# Get file name from the path.
exports.getFileName = (path) ->
  if !path
    return null
  filePathTokens = path.split("/")
  if filePathTokens.length == 0
    return null
  fileNameTokens = filePathTokens[filePathTokens.length - 1].split(".")
  return fileNameTokens[0]   

# Get file extension from the path.
exports.getFileExt = (path) ->
  if !path
    return null
  filePathTokens = path.split("/")
  if filePathTokens.length == 0
    return null
  fileNameTokens = filePathTokens[filePathTokens.length - 1].split(".")
  if fileNameTokens.length < 2
    return ""
  return fileNameTokens[fileNameTokens.length - 1]   


# Copy array of files to destination folder.
exports.copyToDir = (files, dst, callback) ->
  for file in files then do () ->
    filename = path.basename file
    fsExta.copy file, "#{dst}/#{filename}", callback