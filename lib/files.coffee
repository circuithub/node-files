fs       = require "fs"

{check}  = require "validator"
request  = require "request"


# Method for fetching file from URL into specified path.
exports.fetchFromUrl = (url, path, callback) ->
  if !url or !path or !callback
    callback {code: "invalidArguments", message: "Mandatory arguments weren't specified"}
  try
    check(url).isUrl() # check url for validity
    req = request url, (err, response, body) ->
      if err or response.statusCode != 200
        callback {code: "fileNotFound", message: "File not found"}  # error callback
    req.on "end", () ->
      callback undefined, path # success callback
    req.pipe fs.createWriteStream(path)
  catch error
    callback {code: "invalidURL", message: "Invalid file URL"}  # error callback

exports.getFileName = (path) ->
  if !path
    return null
  filePathTokens = path.split("/")
  if filePathTokens.length == 0
    return null
  fileNameTokens = filePathTokens[filePathTokens.length - 1].split(".")
  return fileNameTokens[0]   