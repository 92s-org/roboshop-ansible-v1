#!/bin/bash
# Runs RoboShop playbooks stage by stage.
# Playbooks inside a stage run in parallel; the next stage starts only
# when every playbook in the current stage succeeded.

LOG_DIR=./logs
mkdir -p $LOG_DIR

stage() {
  local pids=() names=()
  echo "===== starting: $* ====="

  for pb in "$@"; do
    name=${pb%.yaml}
    # separate log per playbook, so parallel runs don't mix their output
    ANSIBLE_LOG_PATH=$LOG_DIR/$name.log ansible-playbook $pb > $LOG_DIR/$name.out 2>&1 &
    pids+=($!)
    names+=($pb)
  done

  local failed=0
  for i in "${!pids[@]}"; do
    if wait ${pids[$i]}; then
      echo "SUCCESS : ${names[$i]}"
    else
      echo "FAILURE : ${names[$i]}  (see $LOG_DIR/${names[$i]%.yaml}.out)"
      failed=1
    fi
  done

  if [ $failed -ne 0 ]; then
    echo "stage failed, stopping"
    exit 1
  fi
}

#stage 01-mongodb.yaml 02-redis.yaml 03-mysql.yaml 04-rabbitmq.yaml
stage 05-catalogue.yaml 06-user.yaml 07-cart.yaml 08-shipping.yaml 09-payment.yaml 10-frontend.yaml
stage 11-frontend.yaml

echo "===== RoboShop setup complete ====="