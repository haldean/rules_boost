include_pattern = "boost/%s/"
hdrs_patterns = [
  "boost/%s.h",
  "boost/%s.hpp",
  "boost/pending/%s.h",
  "boost/pending/%s.hpp",
  "boost/%s/**/*.hpp",
  "boost/%s/**/*.ipp",
  "boost/%s/**/*.h",
  "libs/%s/src/*.ipp",
]
srcs_patterns = [
  "libs/%s/src/*.cpp",
  "libs/%s/src/*.hpp",
]

def srcs_list(library_name):
  return native.glob([p % (library_name,) for p in srcs_patterns])

def includes_list(library_name):
  return [".", include_pattern % library_name]

def hdr_list(library_name):
  return native.glob([p % (library_name,) for p in hdrs_patterns])

def boost_library(name, defines=None, includes=None, hdrs=None, srcs=None, deps=None, copts=None):
  if defines == None:
    defines = []

  if includes == None:
    includes = []

  if hdrs == None:
    hdrs = []

  if srcs == None:
    srcs = []

  if deps == None:
    deps = []

  if copts == None:
    copts = []

  return native.cc_library(
    name = name,
    visibility = ["//visibility:public"],
    defines = defines,
    includes = includes_list(name) + includes,
    hdrs = hdr_list(name) + hdrs,
    srcs = srcs_list(name) + srcs,
    deps = deps,
    copts = copts,
    licenses = ["notice"],
  )

def boost_deps():
  native.new_http_archive(
    name = "boost",
    url = "https://sourceforge.net/projects/boost/files/boost/1.64.0/boost_1_64_0.tar.bz2/download",
    build_file = "@boost_rules//:BUILD.boost",
    type = "tar.bz2",
    strip_prefix = "boost_1_64_0/",
    sha256 = "7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332",
  )
