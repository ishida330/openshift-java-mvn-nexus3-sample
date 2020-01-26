#!/bin/sh
# 1. warを作る
echo "================================================"
echo " 1. mvn package"
echo "================================================"
mvn package
# 2. docker imageを作る
echo "================================================"
echo " 2. build base s2i image"
echo "================================================"
docker build -t my-liberty .
# 3. イメージをOpenShiftの内部レジストリーに登録する
echo "================================================"
echo " 3. push base s2i image to openshift repo"
echo "================================================"
./push_img.sh my-liberty p1/my-liberty
docker images|grep my-
# 4. oc new-app
# /bin/sh: /usr/local/s2i/assemble: Permission denied
echo "================================================"
echo " 4. delete all on openshift( for re-run )"
echo "================================================"
oc get all --selector app=simple -o name
oc delete all --selector app=simple
echo "================================================"
echo " 5. oc new-app ( s2i )"
echo "================================================"
oc new-app my-liberty:latest~/. --name=simple
sleep 10s
echo "================================================"
echo " 6. oc status"
echo "================================================"
oc status
echo "================================================"
echo " 7. oc expose svc"
echo "================================================"
#oc start-build --from-dir . simple
oc expose svc/simple