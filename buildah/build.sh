#!/usr/bin/env bash

build_image_name=$1
base=docker.io/library/centos
tag=7
deps="epel-release rpmdevtools gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools"
proj_dir=$(git rev-parse --show-toplevel)

buildah rm -a
newcontainer=$(buildah from $base:$tag)
buildah run $newcontainer -- yum install -y $deps
buildah run $newcontainer -- yum install -y epel-rpm-macros
buildah run $newcontainer -- rpmdev-setuptree
buildah copy $newcontainer $proj_dir/specs/python-pyzabbix.spec /root/rpmbuild/SPECS/
buildah config --workingdir /root/rpmbuild/SPECS/ $newcontainer
buildah run $newcontainer -- yum-builddep -y python-pyzabbix.spec
buildah run $newcontainer -- spectool -g -R python-pyzabbix.spec
buildah config --cmd "rpmbuild -ba python-pyzabbix.spec" $newcontainer
buildah commit $newcontainer $build_image_name

echo done!
