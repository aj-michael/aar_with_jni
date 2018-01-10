def aar_with_jni(name, android_library):
  native.genrule(
      name = name + "_binary_manifest_generator",
      outs = [name + "_generated_AndroidManifest.xml"],
      cmd = """
cat > $(OUTS) <<EOF
<manifest
  xmlns:android="http://schemas.android.com/apk/res/android"
  package="does.not.matter">
  <uses-sdk android:minSdkVersion="999"/>
</manifest>
EOF
""",
  )

  native.android_binary(
      name = name + "_binary",
      manifest = name + "_generated_AndroidManifest.xml",
      custom_package = "does.not.matter",
      deps = [android_library],
  )

  native.genrule(
      name = name,
      srcs = [android_library + ".aar", name + "_binary_unsigned.apk"],
      outs = [name + ".aar"],
      cmd = """
cp $(location {}.aar) $(location :{}.aar)
chmod +w $(location :{}.aar)
origdir=$$PWD
cd $$(mktemp -d)
unzip $$origdir/$(location :{}_binary_unsigned.apk) "lib/*"
cp -r lib jni
zip -r $$origdir/$(location :{}.aar) jni/*/*.so
""".format(android_library, name, name, name, name),
  )
