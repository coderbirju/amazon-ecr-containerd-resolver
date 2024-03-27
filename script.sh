#!/bin/bash -e
set -e
for i in $(seq 1 4); do
for j in $(seq 1 10); do
  >&2 echo "Run: $j with parallel arg: $i"
  ECR_PULL_PARALLEL=$i
  >&2 sudo service containerd stop
  >&2 sudo rm -rf /var/lib/containerd
  >&2 sudo mkdir -p /var/lib/containerd
  >&2 sudo service containerd start
  CGROUP_PARENT="ecr-pull-benchmark"
  CGROUP_CHILD="count-$j-parallel-${ECR_PULL_PARALLEL}-slice"
  CGROUP=${CGROUP_PARENT}/${CGROUP_CHILD}
  IMAGE_URL="ecr.aws/arn:aws:ecr:us-west-1:020023120753:repository/500mb-single:latest"
  sudo mkdir -p /sys/fs/cgroup/${CGROUP}
  sudo echo '+memory' | sudo tee /sys/fs/cgroup/${CGROUP_PARENT}/cgroup.subtree_control
  sudo echo '+cpu' | sudo tee  /sys/fs/cgroup/${CGROUP_PARENT}/cgroup.subtree_control
  OUTPUT_FILE="/tmp/${CGROUP_CHILD}"
  sudo ./test.sh ${CGROUP} ${OUTPUT_FILE} sudo ECR_PULL_PARALLEL="${ECR_PULL_PARALLEL}" ./bin/ecr-pull ${IMAGE_URL}
  ELAPSED=$(grep elapsed ${OUTPUT_FILE}| tail -n 1)
  TIME=$(cut -d" " -f 2 <<< "${ELAPSED}" | sed -e 's/s//')
  SPEED=$(sed -e 's/.*(//' -e 's/)//' <<< "${ELAPSED}" | cut -d" " -f 1)
  >&2 echo "${ELAPSED}"
  MEMORY=$(cat /sys/fs/cgroup/${CGROUP}/memory.peak)
  CPU=$(cat /sys/fs/cgroup/${CGROUP}/cpu.stat)
  echo "Parallel: ${ECR_PULL_PARALLEL},Time: ${TIME},Speed: ${SPEED},Memory: ${MEMORY}"
  echo "{
    \"Parallel layers\": ${ECR_PULL_PARALLEL},
    \"Pull Time\": ${TIME},
    \"Speed\": ${SPEED},
    \"Memory\": ${MEMORY}
  }" >> results.json
  sudo rm ${OUTPUT_FILE}
  sudo rmdir /sys/fs/cgroup/${CGROUP}
done
done

# 020023120753.dkr.ecr.us-west-1.amazonaws.com/500mb-single