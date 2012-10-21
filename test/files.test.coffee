should = require "should"
files  = require "../lib/files"


describe "files", ->
  describe "#fetchFromUrl", ->
    it "should fetch for valid input", (done) ->
      files.fetchFromUrl "https://github.com/circuithub/node-files/zipball/master", "./test.zip", (err, path) ->
        should.not.exist err
        path.should.eql "./test.zip"
        done()
     it "should fail for invalid url", (done) ->
      files.fetchFromUrl "not-an-url", "./test.zip", (err, path) ->
        err.code.should.eql "invalidURL"
        err.message.should.eql "\'not-an-url\' is invalid file URL"
        should.not.exist path
        done() 
     it "should fail for null url", (done) ->
      files.fetchFromUrl null, "./test.zip", (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()  
     it "should fail for undefined url", (done) ->
      files.fetchFromUrl undefined, "./test.zip", (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()  
     it "should fail for null path", (done) ->
      files.fetchFromUrl "https://github.com/circuithub/node-files/zipball/master", null, (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()  
     it "should fail for undefined path", (done) ->
      files.fetchFromUrl "https://github.com/circuithub/node-files/zipball/master", undefined, (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done() 
     it "should fail for valid url that doesn't exist", (done) ->
      files.fetchFromUrl "https://circuithub-invalid-url.com/file", "./test.zip", (err, path) ->
        err.code.should.eql "fileNotFound"
        err.message.should.eql "File wasn't found on URL 'https://circuithub-invalid-url.com/file'"
        should.not.exist path
        done()       
  describe "#findUrlContentHash", ->
   it "should return valid content hash for valid input", (done) -> 
      files.findUrlContentHash "http://cloud.github.com/downloads/circuithub/node-files/index.coffee", (err, hash) ->
        should.not.exist err
        hash.should.eql "37f53f3f9825245ab746f24655adf75c"
        done()     
     it "should fail for null url", (done) ->
      files.findUrlContentHash null, (err, hash) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist hash
        done()  
     it "should fail for undefined url", (done) ->
      files.findUrlContentHash undefined, (err, hash) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist hash
        done()                 
  describe "#fetchFromUrlToHash", ->
    it "should fetch for valid input", (done) ->
      files.fetchFromUrlToHash "http://cloud.github.com/downloads/circuithub/node-files/index.coffee", "./", ".zip", (err, path) ->
        should.not.exist err
        path.should.eql "./37f53f3f9825245ab746f24655adf75c.zip"
        done()
     it "should fail for invalid url", (done) ->
      files.fetchFromUrlToHash "not-an-url", "./test.zip", ".zip", (err, path) ->
        err.code.should.eql "invalidURL"
        err.message.should.eql "\'not-an-url\' is invalid file URL"
        should.not.exist path
        done() 
     it "should fail for null url", (done) ->
      files.fetchFromUrlToHash null, "./test.zip", ".zip", (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()  
     it "should fail for undefined url", (done) ->
      files.fetchFromUrlToHash undefined, "./test.zip", ".zip", (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()  
     it "should fail for null path", (done) ->
      files.fetchFromUrlToHash "https://github.com/circuithub/node-files/zipball/master", null, ".zip", (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()  
     it "should fail for undefined path", (done) ->
      files.fetchFromUrlToHash "https://github.com/circuithub/node-files/zipball/master", undefined, ".zip", (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done() 
     it "should fail for undefined extension", (done) ->
      files.fetchFromUrlToHash "https://github.com/circuithub/node-files/zipball/master", "./", undefined, (err, path) ->
        err.code.should.eql "invalidArguments"
        err.message.should.eql "Mandatory arguments weren't specified"
        should.not.exist path
        done()         
     it "should fail for valid url that doesn't exist", (done) ->
      files.fetchFromUrlToHash "https://circuithub-invalid-url.com/file", "./test.zip", ".zip", (err, path) ->
        err.code.should.eql "fileNotFound"
        err.message.should.eql "File wasn't found on URL 'https://circuithub-invalid-url.com/file'"
        should.not.exist path
        done()                 
  describe "#getFileName", ->
    it "should return valid filename for valid path", ->
      files.getFileName("../path/my-file.pdf").should.eql "my-file"
    it "should return valid filename for simple path", ->
      files.getFileName("./my-file.pdf").should.eql "my-file"
    it "should return valid filename for path with filename without extension", ->
      files.getFileName("./my-file").should.eql "my-file"
    it "should return null for null path", ->
      should.not.exist files.getFileName(null)
    it "should return null for undefined path", ->
      should.not.exist files.getFileName(undefined)
  describe "#getFileExt", ->
    it "should return valid filename for valid path", ->
      files.getFileExt("../path/my-file.pdf").should.eql "pdf"
    it "should return valid filename for file name with few dots", ->
      files.getFileExt("../path/my.file.pdf").should.eql "pdf"      
    it "should return valid filename for simple path", ->
      files.getFileExt("./my-file.pdf").should.eql "pdf"
    it "should return '' for path with filename without extension", ->
      files.getFileExt("./my-file").should.eql ""
    it "should return null for null path", ->
      should.not.exist files.getFileExt(null)
    it "should return null for undefined path", ->
      should.not.exist files.getFileExt(undefined)     