#!/bin/bash -e
set -e
echo "3gb-1-layer-no-concurrency-no-parallelism" >> results.json

declare -a pull_times
declare -a speeds
declare -a memories


sudo rm results.json
sudo rm results_averages.json
sudo rm -rf ./bin
sudo make build
echo "[ {" >> results.json
count=0
for j in $(seq 1 5); do
  ECR_PULL_PARALLEL=0
  >&2 sudo service containerd stop
  >&2 sudo rm -rf /var/lib/containerd
  >&2 sudo mkdir -p /var/lib/containerd
  >&2 sudo service containerd start
  CGROUP_PARENT="ecr-pull-benchmark"
  CGROUP_CHILD="count-$j-parallel-${ECR_PULL_PARALLEL}-slice"
  CGROUP=${CGROUP_PARENT}/${CGROUP_CHILD}
  IMAGE_URL="020023120753.dkr.ecr.us-west-1.amazonaws.com/3gb-single:latest"
  TOKEN="eyJwYXlsb2FkIjoiNGhwaHd6OXByMGxDdS80WlNBRW1CRVFoMmttV1pEcmE5SHdvaExuU0RiVkF3K3ZMWUhNRkZpWUNiZ3MvWmFwbjQwc3hyY3BoR09vTEhGSTJaZG9zeHA3TjhBVi8vKzNDWHZwUDhUNFZacFEvRnJjbURHMzJ4eHJsUGFiSmhIU1pWbVY0dnNtZVJCYjR4Q1piZ0Zub1NyN0lLNWgycXU4VnYwL25TQU9KUlEzUTdMOFA3b0hJUm0xN2dQNGd4RGhJRGwyaTZBTWRmOXdOSUVPT3lUQW96RUxRY0gvaE45S1JsMk5SWXlKcU53S3JHR2lybHQ4d1dkZksrQjhHVkt3Uk5rKzg3R0wrbHVlZXJGWmJRRzg1bk5hN0ZlbmhNazJnZ0h1VjJubEs4eVJoQ3V0S0s3dTIrWkd6amVBTEVwMnNJQUJhVjZSRW90WVhsd3Q5d3RYVmhHdGd0UGprSlZVS3kvU0tUM0Fyb0tieDhIRW9Nd3hzdTJOYTYydHQ3VHBxczRWQ25VaTgxYzB5dllHMXdKVSsyZkJ4ZUFVR3ROWHVPNmU1V3RYaE1xQk9qdWxPeVRQZ2YwaEZBSDZ6eXRTeU53QmxWd2FxbEYvd2hkSmVhMHNjRnZld2J2aXNVMWdWUVV3VTYwYTNLMjhONkw2d2NhU0ZLQ0g5NnBLR3pjak13N3RqdjJsd0ZCS2x3MGllNTIwZHJmYlU3bFFoSy9rcExlM1E5UHczQVhmVW4rZFZVNkpUMEtOV1lLSkZLZDUvMENoOUZvSmJwa3B1OFBhbFc4OUhNOVNWZmFwUTFrZEdHWTZiajF5T0lEY1hTWFBvZjdlMEkwUUJLeWZHaEk3S2hUVlU2UnlPNThFcjFCbVJVM2hlZVkvL1BkL0Y2NS84c2J3QmxvOXhmOUhRSkgrNUZhUnhTa0J0QTBGOWhnVHVwMjVvanVyTDhzOTBHVjh3VWlzODRVRHp0RDhRenRTOWFwYVBBODBWbUtQMXdoTEdoVHd6OWNRUmc1UkNRMW5vcStBdXNnUWFBSzRIWStDMXBibDBKdzJqeFU2Z0xZK21VSElVRjFkcEtScTUzTmhnZ3JKNkI3dHhYaTUxMzJ3U1FNclhqc2pLcnBqeXlqYmhSem5pOWRNbUxoMElrS0ZENTF0VHdmTDNwN3NvaWQ1T1ZrMG1RWHZ3UDFtWTZKY3VVbTVQOFBJUlUwT29tWjBzdW5CYSszS1AxTDhwNDNaYmd3aWdHc3IrTU4ySG5hRlNacFNUOC9sMDZxcW9NOEpLUjlPTTVBVmVqMU82RVZYcDFScVpwL1VVRkdmK01wY0Q0SnFESzVSZHg1Qks1dFZ6TUYzZk5QV1pYWDRjMjB0REx1d1pJMnNOa2pGWk40Z2xrY0NaZWIwVSsrNmQwQjNKOE1GL2hxZnFWR3RiQ1ErWWN5bGhVTndxL201alJuVlllSGQ1cFlHZGtYWUhSc1NFNFZ4UXQxV0F6WkxOZmYzT1RpdTRHbFlHRlNLRkcrNTl4V1dDNVhmc3UyU2hlQTlHY0x0MXJSSVZnOTZlYXhDd3g0Z2pnOWo2bC80Y3lMbVR5NlZJUmpCMnZleDQ3VFlheFN6bG5MQXBRWEI4eWxDUlJKakUwSy9aL01KYWl0SjltNW12dkhVUWF2eDArbnpOVGxGKzVIN1IwanJpZ3l4TG9pVU5aTTJqdENLem1wSDQ4Tm91YnprL25iR2ZqMFY0alM3QTd5OFNpRzk3NDlUL24xTXhCYkVydkszZ1pxMG1iYkx6QnVua0tCWFBEK3psZGs1R1Z6Qks4RDV2Wjk5RHBzSVVZSVYyRE5ZVCs5aC9BaW5sSk9KcVlUbDZCS0RvL2QyRU1pd0Jweis3K2VZWkFNRzNBNkVvNzRrcGl1MDB6b2FXVkkrY2l1VTh4eVJlMnBubU1EMjlua0lqT2xubXBMMHdYY2ZqOGFDOVJCaDN3ODJYVlQ1UlVENnMyelVkZDdDd1JYS3U0OW03NE4zejZvNGtIMnRick91Snl3dXVCcmt5M1dmeEIzRnZneTF0dURzWWRTSDY0WUhzelcwdTQyVFhqYlVhV2hHWm54SzViSnBUVFN1enZUVVQwZjFhUjV4WXgzT0ZpVVhpdkFEZmJhS2N2a0VQQ1VxRWtieE9tUCtKMWFtdHljR3RNeS92NjlTN0o3Q0tsODl4VVpteUZzVHdHSW41TmRuMlB0dWlnQk5iNURJNVFNckNHUktaOWNSaWYwL3pNMUVKUW1xL0l3OFJVdEVMOG5DdlpHV1ZIcDlxbHdPQmtGQ2JubWVhQUtQZG1UR0FJUC9EUThjNzFwNHczQm11ZVRjSGpTZXJOUDlKMER4eCtpL2pJMGxDbkQ4bDMya29UbXk3emRHSGlkV3lIWnRDRCtYTmRKZVBIVndvUGRvTmVNVzNjcVVhNVVId3pOeXFlT0FFVVVxYmRUMEZ0L0JqcGZLL3FJNUJ4WkZyM3R2UlJPNE4rUTdnWjUzZnk1QTZMWlcyN1ZqUFF5eS9hQ0xxb2JSQlMwdUN3Z0NuNzk3VTkvTjYzckpjd21xbE1FdS9CN083ODJCYnVUWGlleVpYRm5yU3hzQ3c3dz09IiwiZGF0YWtleSI6IkFRRUJBSGlqRUZYR3dGMWNpcFZPYWNHOHFSbUpvVkJQYXk4TFVVdlU4UkNWVjBYb0h3QUFBSDR3ZkFZSktvWklodmNOQVFjR29HOHdiUUlCQURCb0Jna3Foa2lHOXcwQkJ3RXdIZ1lKWUlaSUFXVURCQUV1TUJFRURGV29NVlBuUm1xWXJmOWhxUUlCRUlBN0hYeGFza0FMSG9SMm94Tk1hKzRta25PME92ejQ1OWJjUlYwWXBudi9TNjhSaXFUUytMRysxYnVsOUZKb3FmVnBBQUpWY0pnejBOZHVqYms9IiwidmVyc2lvbiI6IjIiLCJ0eXBlIjoiREFUQV9LRVkiLCJleHBpcmF0aW9uIjoxNzEyNjcwNTM4fQ=="
  sudo mkdir -p /sys/fs/cgroup/${CGROUP}
  sudo ctr i rm ${IMAGE_URL}
  sudo echo '+memory' | sudo tee /sys/fs/cgroup/${CGROUP_PARENT}/cgroup.subtree_control
  sudo echo '+cpu' | sudo tee  /sys/fs/cgroup/${CGROUP_PARENT}/cgroup.subtree_control
  OUTPUT_FILE="/tmp/${CGROUP_CHILD}"
  sudo ./test.sh ${CGROUP} ${OUTPUT_FILE} sudo ctr images pull --user "AWS:${TOKEN}" ${IMAGE_URL}
  ELAPSED=$(grep elapsed ${OUTPUT_FILE}| tail -n 1)
  UNPACK=$(grep done ${OUTPUT_FILE}| tail -n 1)
  TIME=$(cut -d" " -f 2 <<< "${ELAPSED}" | sed -e 's/s//')
  SPEED=$(sed -e 's/.*(//' -e 's/)//' <<< "${ELAPSED}" | cut -d" " -f 1)
  >&2 echo "${ELAPSED}"
  MEMORY=$(cat /sys/fs/cgroup/${CGROUP}/memory.peak)
  CPU=$(cat /sys/fs/cgroup/${CGROUP}/cpu.stat)
  UNPACKTIME=$(cut -d" " -f 2 <<< "${UNPACK}" | sed -e 's/s//')
  echo "Parallel: ${ECR_PULL_PARALLEL},Time: ${TIME},Speed: ${SPEED},Memory: ${MEMORY}, DONE: ${UNPACK}, UNPACK: ${UNPACKTIME}"
  tot_Mem=$(( ${MEMORY} / 1048576 ))
  echo "\"run-$j\" : {
    \"Parallel layers\": ${ECR_PULL_PARALLEL},
    \"Pull Time\": ${TIME},
    \"Unpack Time\": ${UNPACKTIME},
    \"Speed\": ${SPEED},
    \"Memory\": ${tot_Mem}
  }," >> results.json
  if [ ${tot_Mem} -ne 0 ]
  then
   pull_times+=("$TIME")
   speeds+=("$SPEED")
   memories+=("$tot_Mem")
   unpack_times+=("$UNPACKTIME")
   count=$((count + 1))
  fi
  sudo rm ${OUTPUT_FILE}
  sudo rmdir /sys/fs/cgroup/${CGROUP}
done
echo "}" >> results.json
 pull_time_avg=$(echo "${pull_times[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
 unpack_time_avg=$(echo "${unpack_times[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
 speed_avg=$(echo "${speeds[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
 memory_avg=$(echo "${memories[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum/NR}')
 total_pull_time=$(echo "${pull_times[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum}')
 total_speed=$(echo "${speeds[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum}')
 total_memory=$(echo "${memories[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum}')
 total_unpack_time=$(echo "${unpack_times[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print sum}')

 echo "\"Averages\":  {
    \"Avg Parallel layers\": ${i},
    \"Avg Pull Time\": ${pull_time_avg},
    \"Avg Unpack Time\": ${unpack_time_avg},
    \"Avg Speed\": ${speed_avg},
    \"Avg Memory\": ${memory_avg},
    \"Total_Download_time\": ${total_pull_time},
    \"Total_speed\": ${total_speed},
    \"Total_mem\": ${total_memory},
    \"Total_Unpack_time\": ${total_unpack_time},
    \"Count\":${count}
 }," >> results_averages.json

 pull_times=()
 speeds=()
 memories=()
 echo "]" >> results.json
 echo "=================================================================" >> results.json