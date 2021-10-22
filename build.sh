#!/bin/bash

echo "$0 $@"

ws=$(dirname "$(readlink -f $0)" )
build_dir=$ws/build_dir
echo "workspace: $ws, build_dir: $build_dir"

branch=$1
openwrt_url="git://git.openwrt.org/openwrt/openwrt.git"
src_dir=source
patches_dir=$ws/patches/$branch


do_fetch() {
  src=$1
  url=$2
  branch=$3
  if [ -d "$branch/.git" ]; then
    echo "cd $branch && git checkout $branch"
    cd $branch 
    git checkout $branch
    cd -
  else
    echo "git clone $url -b $branch  $branch"
    rm -rf $branch $src
    git clone $url -b $branch  $branch
  fi
  rm -rf $src && ln -s $branch $src
}

do_patches() {
  src=$1
  patch=$2
  psrc=$patch/src
  ppatch=$patch/patches
  echo "cp -r $psrc/. $src/"
  cp -r $psrc/. $src/
}

do_feeds() {
  feeds=$1 
  echo "+++++++++++cp ${feeds} feeds.conf++++++++++++++++"
  [ -n "$feeds" ] && cp ${feeds} feeds.conf
  ./scripts/feeds update -a
  ./scripts/feeds install -a
}

do_config() {
  cfg=$1
  echo "+++++++++++cp ${cfg} .config++++++++++++++++"
  [ -n "$cfg" ] && cp ${cfg} .config
  make defconfig
}

do_download() {
  make V=99 -j128 download 
}

do_toolchain() {
  make V=99 -j128 tools/compile 
  make V=99 -j128 toolchain/compile
}
do_build() {
  make V=99 -j128 && echo "+++++++++++++success+++++++++++++" || make V=99 -j1
}
do_clean() {
  make V=99 clean -j64
}

mkdir -p $build_dir
cd $build_dir
do_fetch $src_dir $openwrt_url $branch
do_patches $src_dir $patches_dir
cd $build_dir/$src_dir
do_feeds
do_config
do_download
do_toolchain
do_build

