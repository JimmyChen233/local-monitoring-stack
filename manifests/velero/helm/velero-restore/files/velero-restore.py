#!/usr/bin/python3
import sys
import os
import time
import subprocess
import logging

from datetime import datetime
from typing import List
from typing import Optional, Tuple

stdout_handler = logging.StreamHandler(stream=sys.stdout)
logging.basicConfig(
    level=logging.DEBUG, 
    format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',
    handlers=[stdout_handler]
)

logger = logging.getLogger()

PENDING_RESTORE_STATES = set(["InProgress", "New"])
FAILED_RESTORE_STATES = set(["FailedValidation", "PartiallyFailed", "Failed"])
SUCCEEDED_RESTORE_STATES = set(["Completed"])
CONCLUDED_RESTORE_STATES = SUCCEEDED_RESTORE_STATES.union(FAILED_RESTORE_STATES)



def get_restore_status_for_name(restore_name: str) -> str:
    return subprocess.getoutput(f"kubectl get restore {restore_name} -n velero -o yaml --ignore-not-found | yq .status.phase")


def get_latest_status_for_resource(backup_name: str, resource_name: str) -> Tuple[Optional[str], Optional[str]]:
    all_restores = subprocess.getoutput("kubectl -n velero get restore.velero.io --ignore-not-found").split("\n")
    all_restores = [restore.split(" ")[0].strip() for restore in all_restores[1:]]
    all_restores = [restore for restore in all_restores if f"restore-{resource_name}" in restore]
    all_restores = sorted(all_restores)
    if len(all_restores) == 0:
        return None, None

    latest_restore_name = all_restores[-1]
    return latest_restore_name, get_restore_status_for_name(latest_restore_name)


def wait_for_velero(backup_name: str):
    backup_count: int = 0
    logger.info("Waiting for backups...")

    sleep_duration = 1
    while backup_count == 0:
        logger.info("Checking backup count...")
        backup_count=int(subprocess.getoutput(f"kubectl get backups.velero.io -l velero.io/schedule-name={backup_name} -n velero --ignore-not-found | wc -l"))
        logger.info("Found backup count: %s", backup_count)
        if backup_count == 0:
            logger.info("Waiting for retry...")
            time.sleep(sleep_duration)
            sleep_duration *= 2
    logger.info("Backups ready")


def generate_restore_name(resource_name: str) -> str:
    return datetime.strftime(datetime.now(), f"restore-{resource_name}-%Y%m%d%H%M%S")


def initiate_restore_for_resource(resource_name: str) -> str:
    logger.info("Initiating restore for resource %s...", resource_name)
    with open(f"/{resource_name}/restore-{resource_name}.yaml", "r") as template_file:
        template_yaml = template_file.read()

    new_restore_name = generate_restore_name(resource_name)
    restore_yaml = template_yaml.replace(f"restore-{resource_name}", new_restore_name)

    apply_cmd = f"""
kubectl apply -f - <<EOF
{restore_yaml}
EOF
    """
    result = subprocess.getoutput(apply_cmd)
    if "created" not in result:
        raise RuntimeError(f'Could not initiate restore on {resource_name} with {new_restore_name}! {result}')
    else:
        logger.info("Initiated restore on %s: %s", new_restore_name, result)

    return new_restore_name

#create empty backup
def initiate_empty_backup():
    logger.info("Initiating empty backup for a fresh/migrating platform")
    with open(f"/empty-backup/backup-empty.yaml", "r") as template_file:
        template_yaml = template_file.read()
        
    apply_cmd = f"""
kubectl apply -f - <<EOF
{template_yaml}
EOF
    """
    result = subprocess.getoutput(apply_cmd)
    if "created" not in result and "backup.velero.io/backup-base unchanged" not in result:
        raise RuntimeError("Could not create empty backup")
    else:
        logger.info("Empty backup created or already existed previously")


#create empty restore
def initiate_empty_restore(resource_name: str):
    logger.info("Initiating dummy restore for a fresh platform")
    with open(f"/empty-restore/restore-empty.yaml", "r") as template_file:
        template_yaml = template_file.read()
        new_restore_name = generate_restore_name(resource_name)
        restore_yaml = template_yaml.replace("restore-placeholder", f"restore-{resource_name}")
        
    apply_cmd = f"""
kubectl apply -f - <<EOF
{restore_yaml}
EOF
    """
    result = subprocess.getoutput(apply_cmd)
    if "created" not in result:
        raise RuntimeError(f'Could not initiate restore on {resource_name} with {new_restore_name}! {result}')
    else:
        logger.info("Initiated restore on %s: %s", new_restore_name, result)

def await_restore_conclusion(restore_name: str) -> str:
    logger.info("Awaiting conclusion of %s...", restore_name)
    current_status = get_restore_status_for_name(restore_name)
    while current_status not in CONCLUDED_RESTORE_STATES:
        logger.info("Current restore has not concluded... latest status: %s", current_status)
        time.sleep(10)
        current_status = get_restore_status_for_name(restore_name)

    return current_status

def restore_resource(backup_name: str, resource_name: str):
    logger.info("Checking state for %s...", resource_name)
    current_restore_name, latest_status = get_latest_status_for_resource(backup_name, resource_name)
    if current_restore_name is None:
        logger.info("No existing restores found!")
    else:
        logger.info("Found latest restore %s with status %s!", current_restore_name, latest_status)

    if latest_status in SUCCEEDED_RESTORE_STATES:
        logger.info("Restore %s for %s already completed successfully, skipping!", current_restore_name, resource_name)
        return
    
    if latest_status not in PENDING_RESTORE_STATES:
        # There is no restore currently running, and it didn't succeed - let's do one
        current_restore_name = initiate_restore_for_resource(resource_name)
        
    latest_status = await_restore_conclusion(current_restore_name)

    while latest_status not in SUCCEEDED_RESTORE_STATES:
        wait_time = 5 * 60
        logger.info("Restore %s for %s concluded unsuccessfully... waiting %s seconds before retrying...", current_restore_name, resource_name, wait_time)
        time.sleep(wait_time)

        current_restore_name = initiate_restore_for_resource(resource_name)
        latest_status = await_restore_conclusion(current_restore_name)

    if latest_status in SUCCEEDED_RESTORE_STATES:
        logger.info("Restore %s for %s concluded successfully!", current_restore_name, resource_name)


def restore_all(backup_name: str, resources_to_restore: List[str]):
    wait_for_velero(backup_name)
    for resource_name in resources_to_restore:
        restore_resource(backup_name, resource_name)


if __name__ == "__main__":
    backup_name = "backup-base"
    resources_to_restore = ["namespaces", "secrets", "certs", "kafkaclusters", "configmaps", "pvc", "pgclusters"]  # Be aware that this ordering is the execution order
    # parser = argparse.ArgumentParser
    dummy_restore = False
    for r in sys.argv:
        if r == "dummyrestore":
            dummy_restore = True
    if dummy_restore:
        logger.info("empty restore triggered")
        initiate_empty_backup()
        for resource in resources_to_restore:
            initiate_empty_restore(resource)
    else:
        logger.info("normal process triggered ")
        restore_all(backup_name, resources_to_restore)
