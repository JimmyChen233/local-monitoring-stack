You can test the restore locally with:
1. Make sure you have a tunnel open to the cluster you want to test on.
2. `./test-restore.sh` to start a bash session in a container exactly like the one you would have in the job. It will also set up the kubectl credentials for you.
3. `python velero-restore.py`