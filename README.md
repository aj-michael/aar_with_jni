A workaround to build `.aar` files from Bazel `android_library` rules with
native dependencies.

This is a workaround, not an official solution.

Usage:

```
# WORKSPACE
http_archive(
    name = "aar_with_jni",
    url = "https://api.github.com/repos/aj-michael/aar_with_jni/tarball/8a9a1d19bbbc8fddaaf15e7a9c7fd395d9a9db83",
    sha256 = "08b18b4555c9ad51deaee8636e5e525721a9cd66814fa10434d125284aedfa4f",
    strip_prefix = "aj-michael-aar_with_jni-8a9a1d1",
    type = "tgz",
)
```

```
# example/BUILD
load("@aar_with_jni//:aar_with_jni.bzl", "aar_with_jni")

aar_with_jni(
    name = "my_aar",
    android_library = ":my_android_library",
)

android_library(
    name = "my_android_library",
    manifest = "AndroidManifest.xml",
    custom_package = "com.example",
    srcs = ["Foo.java"],
    deps = [":my_cc_library"],
)

cc_library(
    name = "my_cc_library",
    srcs = ["foo.cc"],
)
```

To build:

```
$ bazel build --fat_apk_cpu=armeabi-v7a,x86 //example:my_aar
...
Target //example:my_aar up-to-date:
  bazel-genfiles/example/my_aar.aar
```
