# cyuri
Fast URI Parser for Python.

This is a wrapper for [liburi](https://github.com/nevali/liburi) which is based on [uriparser](http://uriparser.sourceforge.net/).

# Example

    >>> import cyuri
    
    >>> u = cyuri.uriparser()
    
    >>> u.join("http://test.com","/")
    'http://test.com/'
    
    >>> u.join("http://test.com","/a/b/c/../d/üml/e/../..")
    'http://test.com/a/b/d/'
    
    >>> u.join("http://test.com","/a/b/c/../d/üml/")
    'http://test.com/a/b/d/%C3%BCml/'
    
    >>> u.join("http://test.com","https://test.com/a/b/c/../d/üml/")
    'https://test.com/a/b/d/%C3%BCml/'
    
    >>> u.join("http://test.com","https://anothertest.com/a/b/c/../d/üml/")
    'https://anothertest.com/a/b/d/%C3%BCml/'
    
    >>> u.join("http://test.com","index.html?query=test")
    'http://test.com/index.html?query=test'
    
    >>> u.components( u.join("http://test.com","index.html?query=test") )
    {'fragment': None, 'auth': None, 'host': 'test.com', 'query': 'query=test', 'path': '/index.html', 'scheme': 'http', 'port': None}
    
    >>> u.components( u.join("http://sub.test.com","index.html?query=test") )
    {'fragment': None, 'auth': None, 'host': 'sub.test.com', 'query': 'query=test', 'path': '/index.html', 'scheme': 'http', 'port': None}
    
    >>> u.components( u.join("http://sub.test.com:80","index.html/test/b/c/d/?e=f") )
    {'fragment': None, 'auth': None, 'host': 'sub.test.com', 'query': 'e=f', 'path': '/index.html/test/b/c/d/', 'scheme': 'http', 'port': '80'}
    
    
# API

### uriparser.components 

Returns a dictionary of components such as host, query , path and ...

uriparser_instance.components( URI_STRING ) -> {'fragment': None, 'auth': None, 'host': None, 'query': None, 'path': None, 'scheme': None, 'port': None}


### uriparser.join

Returns a new URI by joining relative to Base URI. It returns empty string on failure.

uriparser_isntance.join( BASEURI, URI ) -> Relative URI

# Requirements

1. Cython 0.23
2. liburi
