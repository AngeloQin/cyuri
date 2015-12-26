from libc.stdlib cimport malloc,realloc, free
from libc.locale cimport LC_ALL, setlocale

cimport liburi
cimport cython

setlocale(LC_ALL,"")

@cython.freelist(10)
cdef class uriparser:
	cdef liburi.URI* _parse_uri(self, char *basestr, char *uristr):
		cdef liburi.URI *uri
		cdef liburi.URI *rel
		cdef liburi.URI *base

		base = liburi.uri_create_str(basestr, NULL);
		if base is NULL: return NULL

		rel = liburi.uri_create_str(uristr, NULL);
		if rel is NULL: return NULL

		uri = liburi.uri_create_uri(rel, base);
		if uri is NULL: return NULL

		liburi.uri_destroy(base);
		liburi.uri_destroy(rel);
		
		return uri;
	
	cdef bytes _print_uri(self,liburi.URI *uri):
		cdef size_t len
		cdef char *buffer
		cdef bytes result

		len = liburi.uri_str(uri, NULL, 0)
		if not len:
			return <bytes>""

		buffer = <char *>malloc(len)
		if not buffer:
			return <bytes>""

		len = liburi.uri_str(uri, buffer, len)
		if not len: 
			return <bytes>""
		
		result = <bytes>buffer

		free(buffer)

		return result

	cpdef join(self,bytes base,bytes uri_):
		cdef liburi.URI *uri

		uri = self._parse_uri(base,uri_)
		
		return self._print_uri(uri)

	cdef int _printcomp(self, liburi.URI *uri, size_t (*fn)(liburi.URI *, char *, size_t), char **buffer, size_t 
*len):
		cdef size_t r
		cdef char *p
		
		r = fn(uri,buffer[0],len[0])
		if r == sizeof(size_t) - 1 : return -1

		if r > len[0]:
			p = <char *> realloc(buffer[0],r)
			if p is NULL: 
				return -1

			buffer[0] = p
			len[0] = r
			r = fn(uri, buffer[0], len[0])
			
			if r == sizeof(size_t) - 1:
				return -1

		if r == 0:
			return -1

		return 1

	cdef dict _parse_comp_uri(self,liburi.URI *uri):
		cdef char *buffer = NULL
		cdef size_t len = 0
		cdef int r = 0
		
		cdef dict result = {
			"scheme":None,
			"auth":None,
			"host":None,
			"port":None,
			"path":None,
			"fragment":None }


		if self._printcomp(uri,liburi.uri_scheme,&buffer,&len) == 1:		
			result["scheme"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0

		if self._printcomp(uri,liburi.uri_auth,&buffer,&len) == 1:
			result["auth"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0

		if self._printcomp(uri,liburi.uri_host,&buffer,&len) == 1:
			result["host"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0

		if self._printcomp(uri,liburi.uri_port,&buffer,&len) == 1:
			result["port"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0

		if self._printcomp(uri,liburi.uri_path,&buffer,&len) == 1:
			result["path"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0

		if self._printcomp(uri,liburi.uri_query,&buffer,&len) == 1:
			result["query"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0

		if self._printcomp(uri,liburi.uri_fragment,&buffer,&len) == 1:
			result["fragment"] = <bytes>buffer
			free(buffer)
			buffer = NULL
			len = 0
			
		
		return result


	cpdef components(self,bytes uri):
		cdef liburi.URI *_uri = NULL
		cdef dict result 

		if len(uri) == 0 : raise ValueError("Empty string")

		_uri = liburi.uri_create_str(uri, NULL);

		result = <dict>self._parse_comp_uri(_uri)

		return result

		
