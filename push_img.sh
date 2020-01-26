#!/bin/bash
echo "ローカルのDockerイメージをMiniShiftの内部リポジトリに登録します(oc registry info --> 172.30.1.1:5000)"
if [ $# -ne 2 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには2個の引数が必要です。 ex. reg_img my/nodejs p1/nodejs " 1>&2
  echo "#1 ...docker imagesで表示されるlocal docker containerのイメージ名 " 1>&2
  echo "#2 ...OpenShiftへ登録する名前 プロジェクト名/イメージ名の形式であること! " 1>&2
  exit 1
fi
echo "#1:$1"
echo "#2:$2"
myhost=`hostname -i`
echo $myhost
oc login -u developer -p pass https://$myhost:8443
docker tag $1 $(oc registry info)/$2:latest
docker login -u $(oc whoami) -p $(oc whoami -t) $(oc registry info)
docker push $(oc registry info)/$2:latest
echo "登録しました."
