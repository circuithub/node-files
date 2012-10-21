fs       = require "fs"
path     = require "path"
util     = require "util"
uuid     = require "node-uuid"
crypto   = require "crypto"

async    = require "async"
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
      if err or response.statusCode != 200 # error callback
        callback {code: "fileNotFound", message: "File wasn't found on URL '#{url}'"}
        return
      callback undefined, path # success callback  
    req.pipe fs.createWriteStream(path)
  catch error
    callback {code: "invalidURL", message: "'#{url}' is invalid file URL"} 

# Method for fetching file from URL into specified path, using the content of the fetched file 
# as the filename. Passes the complete path and filename back.
exports.fetchFromUrlToHash = (url, path, extension, callback) ->
  if !url or !path or !callback or !extension
    callback {code: "invalidArguments", message: "Mandatory arguments weren't specified"}
    return
  try
    check(url).isUrl() # check url for validity
    tempId = uuid.v1()
    fileStream = fs.createWriteStream(path + tempId)
    md5sum = crypto.createHash("md5")    
    req = request url, (err, response, body) ->
      if err or response.statusCode != 200
        callback {code: "fileNotFound", message: "File wasn't found on URL '#{url}'"}  # error callback
        return       
      newPath = path + md5sum.digest("hex") + extension
      fs.rename path + tempId, newPath, ->
        callback undefined, newPath # success callback
    req.on "data", (d) ->
      md5sum.update d
    req.pipe fileStream      
  catch error
    callback {code: "invalidURL", message: "'#{url}' is invalid file URL"}  # error callback


# Method for finding content hash for file behind url.
exports.findUrlContentHash = (url, callback) ->
  if !url
    callback {code: "invalidArguments", message: "Mandatory arguments weren't specified"}
    return
  try
    check(url).isUrl() # check url for validity
    md5sum = crypto.createHash("md5")    
    req = request url, (err, response, body) ->
      if err or response.statusCode != 200
        callback {code: "fileNotFound", message: "File wasn't found on URL '#{url}'"}  # error callback
        return       
      callback undefined, md5sum.digest("hex")  # success callback
    req.on "data", (d) ->
      md5sum.update d      
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


# Copy file.
# Adapted from https://github.com/coolaj86/node-examples-js/tree/master/fs.extra.
exports.copyFile = (src, dst, callback) ->
  fs.stat dst, (err) ->
    fs.stat src, (err) ->
      if err # check whether source file exists
        callback {code: "fileNotExists", message: "'#{src}' file path is invalid"} 
        return
      readStream = fs.createReadStream src
      writeStream = fs.createWriteStream dst
      util.pump readStream, writeStream, callback

# Copy array of files to destination folder.
exports.copyToDir = (files, dst, callback) ->
  workers = []
  for file in files 
    filename = path.basename file
    worker = async.apply exports.copyFile, file, "#{dst}/#{filename}"
    workers.push worker
  async.parallel workers, (err, results) ->
    if err
      callback err
    else
      callback()        