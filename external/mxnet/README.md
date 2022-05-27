# Usage

```bash
cat mxnet-1.9.1.tar.xz_* > mxnet-1.9.1.tar.xz
tar -xJf mxnet-1.9.1.tar.xz
mv mxnet/ ${ANDROID_JNI_DIR}
```

# How to build MXNET shared library

First of all, clone incubator-mxnet github repositoy as following:
```bash
git clone https://github.com/apache/incubator-mxnet.git
git checkout ${TARGET_VERSION}
```

And then, you can build mxnet shared library using NDK by running ci scripts.
```bash
sudo python3 ci/build.py -p android_armv8
sed -i "s|USE_CPP_PACKAGE OFF|USE_CPP_PACKAGE ON" config/linux.cmake
cp config/linux.cmake config.cmake
sudo make install
```

Once you build & install MXNet, create a new `mxnet/` directory.
Then, move installed `libmxnet.so` into `mxnet/lib` and header files into `mxnet/include`.
```bash
mkdir mxnet/ && mkdir mxnet/lib && mkdir mxnet/include
mv $INSTALL_DIR/libmxnet.so mxnet/lib
mv $INSTALL_DIR/$HEADER_FILES mxnet/include
```

Lastly, archive `mxnet/` directory into `mxnet-$VERSION.tar.xz` and split into several files to upload github.
```bash
tar -cJf mxnet-$VERSION.tar.xz mxnet/
split -b 40m ../mxnet-$VERSION.tar.xz mxnet-$VERSION.tar.xz_
```

