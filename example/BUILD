load("//:aar_with_jni.bzl", "aar_with_jni")

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
