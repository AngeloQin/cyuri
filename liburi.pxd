cdef extern from "liburi.h":
	ctypedef struct URI

	ctypedef struct URI_INFO:
		void *internal
		char *scheme
		char *auth
		char *host
		int port
		char *path
		char *query
		char *fragment

	URI *uri_create_str(const char * uristr, const URI *uri);

	URI *uri_create_uri(const URI * source, const URI * base);

	int uri_destroy(URI *uri);

	int uri_absolute(URI *uri);

	int uri_absolute_path(URI *uri);	

	size_t uri_scheme(URI * uri, char * buf, size_t buflen);

	size_t uri_auth(URI * uri, char * buf, size_t buflen);

	size_t uri_host(URI * uri, char * buf, size_t buflen);

	size_t uri_port(URI * uri, char * buf, size_t buflen);

	size_t uri_path(URI * uri, char * buf, size_t buflen);

	size_t uri_query(URI * uri, char * buf, size_t buflen);

	size_t uri_fragment(URI * uri, char * buf, size_t buflen);

	int uri_portnum(URI *uri);

	size_t uri_str(URI * uri, char * buf, size_t buflen);

	char *uri_stralloc(URI * uri);

	URI_INFO *uri_info(URI *uri);
	
	int uri_info_destroy(URI_INFO *info);

	int uri_equal(URI *a, URI *b);
