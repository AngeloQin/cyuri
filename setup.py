from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

setup(
    ext_modules =cythonize([Extension("cyuri",["cyuri.pyx","./liburi/parse.c"],
			extra_link_args=["-L/usr/local/lib"],
			extra_compile_args=["-I/usr/local/include/uriparser","-I/usr/local/include"],
			libraries=["uri","uriparser"])])
)
