mkdir -p temp
cp ~/.aws/config temp/aws-config
cp ~/.aws/credentials temp/aws-credentials
cp ~/.kube/config temp/kube-config
docker build --tag restore-tester .
docker run --network="host" \
    -v ./files/backup-empty.yaml:/empty-backup/backup-empty.yaml \
    -v ./files/restore-empty.yaml:/empty-restore/restore-empty.yaml \
    -v ./files/velero-restore.py:/apps/velero-restore.py \
 -it restore-tester /bin/bash
