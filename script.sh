#!/bin/bash -e
set -e

declare -a pull_times
declare -a speeds
declare -a memories

imagelist=("ecr.aws/arn:aws:ecr:us-west-1:020023120753:repository/3gb-single:latest")
sudo rm -rf ./bin
sudo make build
for img in $imagelist; do
echo $img >> results_averages.json
echo $img >> results.json
echo "[" >> results.json
for i in $(seq 1 1); do
echo "{" >> results.json
for j in $(seq 1 1); do
  >&2 echo "Run: $j with parallel arg: $i"
  ECR_PULL_PARALLEL=$i
  >&2 sudo service containerd stop
  >&2 sudo rm -rf /var/lib/containerd
  >&2 sudo mkdir -p /var/lib/containerd
  >&2 sudo service containerd start
  CGROUP_PRENT="ecr-pull-benchmark"
  CGROUP_CHILD="count-$j-parallel-${ECR_PULL_PARALLEL}-slice"
  CGROUP=${CGROUP_PARENT}/${CGROUP_CHILD}
  IMAGE_URL=$img
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
  echo "\"run-$j\" : {
    \"Parallel layers\": ${ECR_PULL_PARALLEL},
    \"Pull Time\": ${TIME},
    \"Speed\": ${SPEED},
    \"Memory\": $(( ${MEMORY} / 1048576 ))
  }," >> results.json
  pull_times+=("$TIME")
  speeds+=("$SPEED")
  memories+=("$((${MEMORY} / 1048576))")
  sudo rm ${OUTPUT_FILE}
  sudo rmdir /sys/fs/cgroup/${CGROUP}
done
 echo "}" >> results.json
 pull_time_avg=$(echo "${pull_times[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
 speed_avg=$(echo "${speeds[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
 memory_avg=$(echo "${memories[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')

 echo "\"Averages\":  {
    \"Parallel layers\": ${i},
    \"Pull Time\": ${pull_time_avg},
    \"Speed\": ${speed_avg},
    \"Memory\": ${memory_avg}
 }," >> results_averages.json

 pull_times=()
 speeds=()
 memories=()
done
  echo "]" >> results.json
  echo "=================================================================" >> results.json
done
