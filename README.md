node-files
==========

Simple files' utilities for Node.js

# Overview

Simple utility libraries that have common methods to deal with files, filenames etc.

## Use

Install

`npm install files`


Code

``` coffee

files = require "files"

files.getFileName("./my-file.pdf")
## "my-file"

files.getFileName("./my-file.pdf")
## "pdf"

files.fetchFromUrl "https://github.com/circuithub/node-files/zipball/master", "./download", (err, path) -> ...


files.fetchFromUrlToHash "https://github.com/circuithub/node-files/zipball/master", "./download",  ".zip", (err, path) -> ...

```

That's easy!


## Contributions

If you need any feature tell us or fork project and implement it by yourself.

We appreciate feedback!

## License

(The MIT License)

Copyright (c) 2011-2012 CircuitHub., https://circuithub.com/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.