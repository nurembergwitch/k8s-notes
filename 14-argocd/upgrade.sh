#!/usr/bin/env bash

set -e

new_ver=${1}

echo "new version: ${new_ver}" # must be like "v0.2"

docker tag shitchat:v0.2 dirt1992/nginx:${new_ver}
docker push dirt1992/nginx:${new_ver}

tmp_dir=${mktemp -d}
echo "created a temp dir: ${tmp_dir}"

git clone git@github.com:nurembergwitch/argodemo.git ${tmp_dir} 

# update the image tag
sed -i '' -e "s/dirt1992\/shitchat:.*/dirt1992\/shitchat:${new_ver}/g" ${tmp_dir}/myapp/1-deployment.yaml

cd ${tmp_dir}
git add .
git commit -m "Updated version to ${new_ver}"
git push origin master

# optionally - remove the temp ir
rm -rf ${tmp_dir}
