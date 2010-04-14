hcache
======

Hcache is a header file cache for GCC preprocessor.

Hcache is a band-aid for slow build times when building over a network
filesystem such as ClearCase MVFS. The caching strategy is very simple,
hcache lazily copies all the included header files to your local home
directory. The cache is never invalidated which can cause build failures
if the header files change.


Usage
-----

Hcache is used as a wrapper for GCC, for example:

    hcache gcc -Iinclude -o test test.c

By default, `$HOME/.hcache` is used as the cache directory. The default
can be overridden with the environment variable `$HCACHE_DIR`.

The file `config` in the cache directory can be used to specify the paths
at which include files will be cached. The format of the file is a single
regular expression. For example, 

    ^\/foo

means that include files with paths starting with `/foo` are cached.

For more examples, see the `examples` and `features` directories.


Requirements
------------

-  [Ruby](http://www.ruby-lang.org/)
-  [Cucumber](http://cukes.info/) and [RSpec](http://rspec.info/) for
   feature tests


License
-------

See `LICENSE`.

