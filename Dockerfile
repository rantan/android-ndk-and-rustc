FROM rust:latest

ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK_VERSION r20

RUN apt-get update && \
    apt-get install -y wget unzip

# Setup Android NDK
RUN mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
# uncompress
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
# move to its final location
    mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
# remove temp dir
    cd ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp
# add to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

ENV ANDROID_NDK_TOOLCHAIN_BIN $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin

ENV ARM64_AR $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android-ar
ENV ARM64_LD $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android-ld
ENV ARM64_AS $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android-as
ENV ARM64_RANLIB $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android-ranlib
ENV ARM64_STRIP $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android-strip
ENV ARM64_CC $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android29-clang
ENV ARM64_CXX $ANDROID_NDK_TOOLCHAIN_BIN/aarch64-linux-android29-clang++

ENV ARM_AR $ANDROID_NDK_TOOLCHAIN_BIN/arm-linux-androideabi-ar
ENV ARM_LD $ANDROID_NDK_TOOLCHAIN_BIN/arm-linux-androideabi-ld
ENV ARM_AS $ANDROID_NDK_TOOLCHAIN_BIN/arm-linux-androideabi-as
ENV ARM_RANLIB $ANDROID_NDK_TOOLCHAIN_BIN/arm-linux-androideabi-ranlib
ENV ARM_STRIP $ANDROID_NDK_TOOLCHAIN_BIN/arm-linux-androideabi-strip
ENV ARM_CC $ANDROID_NDK_TOOLCHAIN_BIN/armv7a-linux-androideabi29-clang
ENV ARM_CXX $ANDROID_NDK_TOOLCHAIN_BIN/armv7a-linux-androideabi29-clang++

ENV X86_AR $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android-ar
ENV X86_LD $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android-ld
ENV X86_AS $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android-as
ENV X86_RANLIB $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android-ranlib
ENV X86_STRIP $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android-strip
ENV X86_CC $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android29-clang
ENV X86_CXX $ANDROID_NDK_TOOLCHAIN_BIN/i686-linux-android29-clang++

RUN mkdir .cargo && \
    echo "\
[target.aarch64-linux-android] \n\
ar = \"${ARM64_AR}\" \n\
linker = \"${ARM64_CC}\" \n\
\n\
[target.armv7-linux-androideabi] \n\
ar = \"${ARM_AR}\" \n\
linker = \"${ARM_CC}\" \n\
\n\
[target.i686-linux-android] \n\
ar = \"${X86_AR}\" \n\
linker = \"${X86_CC}\" \
" > .cargo/config && \
    echo "put below into .cargo/config" && \
    cat .cargo/config && \
    rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android && \
    rustup component add rustfmt --toolchain 1.38.0-x86_64-unknown-linux-gnu

RUN ln -s $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/8.0.7/include/stdarg.h $ANDROID_NDK_HOME/sysroot/usr/include/stdarg.h && \
    ln -s $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/8.0.7/include/stddef.h $ANDROID_NDK_HOME/sysroot/usr/include/stddef.h && \
    ln -s $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/8.0.7/include/__stddef_max_align_t.h $ANDROID_NDK_HOME/sysroot/usr/include/__stddef_max_align_t.h

ENV BINDGEN_EXTRA_CLANG_ARGS "--sysroot=${ANDROID_NDK_HOME}/sysroot"
ENV LLVM_CONFIG_PATH $ANDROID_NDK_TOOLCHAIN_BIN/llvm-config
ENV LD_LIBRARY_PATH $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/8.0.7/include:$LD_LIBRARY_PATH

WORKDIR /project
VOLUME /project

CMD AR=$ARM64_AR LD=$ARM64_LD CC=$ARM64_CC CXX=$ARM64_CXX AS=$ARM64_AS RANLIB=$ARM64_RANLIB STRIP=$ARM64_STRIP cargo build --target aarch64-linux-android --release && \
    AR=$ARM_AR LD=$ARM_LD CC=$ARM_CC CXX=$ARM_CXX AS=$ARM_AS RANLIB=$ARM_RANLIB STRIP=$ARM_STRIP cargo build --target armv7-linux-androideabi --release && \
    AR=$X86_AR LD=$X86_LD CC=$X86_CC CXX=$X86_CXX AS=$X86_AS RANLIB=$X86_RANLIB STRIP=$X86_STRIP cargo build --target i686-linux-android --release