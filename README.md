ObjectAngel
===========

Simple Rack middleware to monitor memory allocation/deallocation for objects of a given class, in a per-request basis.

Installation
============

`rails plugin install git://github.com/diogenes/object_angel.git`

Example
=======

In your config/environments/development.rb:

`config.middleware.use 'ObjectAngel', :classes => %w(MyModel AnotherClass)`

Copyright (c) 2012 Diógenes Falcão, released under the MIT license
