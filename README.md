A workaround to build `.aar` files from Bazel `android_library` rules with
native dependencies.

This is a workaround, not an official solution.

Usage:

```
# WORKSPACE
http_archive(
    name = "aar_with_jni",
    url = "https://api.github.com/repos/aj-michael/aar_with_jni/tarball/1f36219a9afc099e910f1cbbf95fd5e85b53fd55",
    sha256 = "5c799a29f36483c2f609b9b410b874ac355210b923e01fc0a620f5cb449ffcb2",
    strip_prefix = "aj-michael-aar_with_jni-1f36219",
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

$ zipinfo bazel-genfiles/example/my_aar.aar
Archive:  bazel-genfiles/example/my_aar.aar
Zip file size: 156371 bytes, number of entries: 6
-rw----     2.0 fat      290 b- defN 80-Jan-01 00:00 AndroidManifest.xml
-rw----     2.0 fat      827 b- defN 80-Jan-01 00:00 classes.jar
-rw----     2.0 fat        0 b- defN 80-Jan-01 00:00 res/
-rw----     2.0 fat        0 b- defN 80-Jan-01 00:00 R.txt
-rw-r--r--  3.0 unx   167616 bx defN 18-Jan-10 14:12
jni/armeabi-v7a/libmy_aar_binary.so
-rw-r--r--  3.0 unx   219436 bx defN 18-Jan-10 14:12 jni/x86/libmy_aar_binary.so
6 files, 388169 bytes uncompressed, 155587 bytes compressed:  59.9%
```

To load, use the name of the `aar_with_jni` rule plus "_jni":

```
System.loadLibrary("my_aar_jni");
```
