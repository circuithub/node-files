should    = require "should"
fileUtils = require "../lib/files"


describe "#getFileName", ->
  it "should return valid filename for valid path", ->
    fileUtils.getFileName("../path/my-file.pdf").should.eql "my-file"
  it "should return valid filename for simple path", ->
    fileUtils.getFileName("./my-file.pdf").should.eql "my-file"
  it "should return valid filename for path with filename without extension", ->
    fileUtils.getFileName("./my-file").should.eql "my-file"
  it "should return null for null path", ->
    should.not.exist fileUtils.getFileName(null)
  it "should return null for undefined path", ->
    should.not.exist fileUtils.getFileName(undefined)