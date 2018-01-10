package com.example;

public class Foo {
  static {
    System.loadLibrary("my_aar_jni");
  }

  public static native String hello();
}
