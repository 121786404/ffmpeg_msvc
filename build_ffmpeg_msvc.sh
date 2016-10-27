#!/bin/sh

arch=x86
archdir=Win32
clean_build=true
debug=true

for opt in "$@"
do
    case "$opt" in
    x86)
            ;;
    x64 | amd64)
            arch=x86_64
            archdir=x64
            ;;
    quick)
            clean_build=false
            ;;
    release)
            debug=false
            ;;
    *)
            echo "Unknown Option $opt"
            exit 1
    esac
done

make_dirs() (
  if $debug ; then
  	mkdir -p bin_${archdir}d/lib
  else
  	mkdir -p bin_${archdir}/lib
  fi
)

clean() (
  make distclean > /dev/null 2>&1
  find . -name "*.exp" -o -name "*.ilk" -o -name "*.pdb" -o -name "*.exe" | xargs rm -f
  rm -f config.out
)

configure() (
  OPTIONS="
    --enable-shared                 \
    --disable-static                \
    --disable-asm                   \
    --disable-mmx                   \
    --disable-mmxext                \
    --disable-dxva2                 \
    --enable-version3               \
    --enable-w32threads             \
    --arch=${arch}"

  EXTRA_CFLAGS="-D_WIN32_WINNT=0x0502 -DWINVER=0x0502 -Zo -GS-"
  EXTRA_LDFLAGS=""

  if $debug ; then
    OPTIONS="${OPTIONS} --enable-debug"
    EXTRA_CFLAGS="${EXTRA_CFLAGS} -MDd"
    EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -NODEFAULTLIB:libcmt"
  else
    EXTRA_CFLAGS="${EXTRA_CFLAGS} -MD"
    EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -NODEFAULTLIB:libcmt"
  fi

  sh configure --toolchain=msvc --extra-cflags="${EXTRA_CFLAGS}" --extra-ldflags="${EXTRA_LDFLAGS}" ${OPTIONS}
)


echo Building ffmpeg in MSVC Debug config...

make_dirs

cd FFmpeg

if $clean_build ; then
    clean

    ## run configure, redirect to file because of a msys bug
    configure > config.out 2>&1
    CONFIGRETVAL=$?

    ## show configure output
    cat config.out
fi

## Only if configure succeeded, actually build
if ! $clean_build || [ ${CONFIGRETVAL} -eq 0 ]; then

  make -j$NUMBER_OF_PROCESSORS

  if $debug ; then
      cp -u lib*/*.dll ../bin_${archdir}d
      cp -u lib*/*.pdb ../bin_${archdir}d
      cp -u lib*/*.lib ../bin_${archdir}d/lib
  else
      cp -u lib*/*.dll ../bin_${archdir}
      cp -u lib*/*.pdb ../bin_${archdir}
      cp -u lib*/*.lib ../bin_${archdir}/lib
  fi

fi

cd ..
