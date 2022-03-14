#!/bin/bash
#
[[ ! -f sada-foundation.tgz ]] || rm sada-foundation.tgz
[[ -d sada-foundation ]] || mkdir sada-foundation
#
echo
echo Preparing......
echo
cp -R 1-bootstrap ./sada-foundation/
cp -R 2-organization ./sada-foundation/
cp -R 3-shared ./sada-foundation/
cp -R 4-dev  ./sada-foundation/
cp -R 5-qa ./sada-foundation/
cp -R 6-uat ./sada-foundation/
cp -R 7-prod ./sada-foundation/
cp -R csr ./sada-foundation/
mkdir ./sada-foundation/docs
mkdir ./sada-foundation/docs/img
cp ./docs/getting_started_fast.md ./sada-foundation/docs/
cp -r ./docs/img/* ./sada-foundation/docs/img/
cp -R modules ./sada-foundation/
cp .gitignore ./sada-foundation/
cp 0-prep.sh ./sada-foundation/
cp 0.5-prep.sh ./sada-foundation/
cp auto_deploy.sh ./sada-foundation/
cp create_groups.py ./sada-foundation/
cp destroy.sh ./sada-foundation/
cp get-gcp-infos.sh ./sada-foundation/
cp README.md ./sada-foundation/
#
echo Packaging......
echo
tar czf ../sada-foundation.tgz sada-foundation
rm -rf sada-foundation
#
export c_dir=$(pwd)
export p_dir="$(dirname "$c_dir")"
echo "Foundation Packaged And Ready For Customer!"
echo
echo "Package Location: $p_dir"
echo "Package Name: sada-foundation.tgz"
echo
#