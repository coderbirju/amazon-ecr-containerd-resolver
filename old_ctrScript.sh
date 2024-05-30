#!/bin/bash -e
set -e
echo "3gb-1-layer-no-concurrency-no-parallelism" >> results.json

declare -a pull_times
declare -a speeds
declare -a memories

echo "[ {" >> results.json
for j in $(seq 1 5); do
  ECR_PULL_PARALLEL=0
  >&2 sudo service containerd stop
  >&2 sudo rm -rf /var/lib/containerd
  >&2 sudo mkdir -p /var/lib/containerd
  >&2 sudo service containerd start
  CGROUP_PARENT="ecr-pull-benchmark"
  CGROUP_CHILD="count-$j-parallel-${ECR_PULL_PARALLEL}-slice"
  CGROUP=${CGROUP_PARENT}/${CGROUP_CHILD}
  IMAGE_URL="020023120753.dkr.ecr.us-west-1.amazonaws.com/1gb-single-layer:latest"
  TOKEN="eyJwYXlsb2FkIjoiVzVSL3l0OGJ2Q2JueVNxNkd6OU1makhwZzR6UXN1UmJqMTVzdW05RlJPdVoxR0YyOURSU1YyQ1Fnc0JXZDIzRzczS20zUDNtWGFza3JtVGc1Ymt4OTlNZHFISGQ2WkVFb3NpaytoNTZuaEc3aHV0aXlIN3BYQkJVMzZ0cEZhOFNKRzZvS0J4azlCQzFIV3NPMGhVUkhPOGpXZUIyamFQVTN4RURxbXNCanpHQ2QyWW9zTVlMS2dpT0pEd2dnT0REZThMR3FGdEdRQ0RhNjQzZFp6U0xFeUVsRWpQVjBzekZCNklLWEVkbTVXbnc4VnNRQXkxNDNxUStEQzlJS2ZkQi9Ia2VTMXJ4dldwTDBHUTVxTm1qNStBOHIrT1h0MkZPYXNWQVUvajRlejU2UTN6MWpFRDdKbXc1U1F5bTg4a0h6SkFtdlhDbkF1YjlOeXNxbjZvcmNHUHpZNWJESDNSWEJsMGdIOUEvTUJaelFteEZHU010eUtjdUZzTHcyQ0R2UmNSdHVRS1Rsbjl3K0FNQzlndlVZNEJtVGwwNWtyODZwWlFSd0VZaU5WOHhzSWt2NHNnWFRnRWRIaWNFTW1QaXlRV04rTFgrWnJSM3VzcThtMWJzOUQ2ZUxiWDRqWkVETDhMR3M0VzAzS3BxeFRDUVk2ZFJJU1ZkNFFXWWtyRzg3TFRVNWFQcXdMYU1KazdMMGtnQkNJdTN3RDczMGlPajBkU0N1SGNXZitORWUwZi9HczRtSEFRNVNRR005MlFKb0UzR1B4a3kxNlQ4cWozTzRzWGhPeVl3TnVRZTRBYllyNEd3eUo4MHUrK0VzZ1NRM0lsd1p1T3RJU2s4c1J5NFNsUjhuQzA0ZzdseXc1bk9oKzFQS2FoSFJHR0xjelFWQkxuYzFUOHdqQ3NXYzFHbWZQVWpDaTM2Sm1YMTVYeXZyS1BPSVhWbkdwVjhiL2pob3h5bmN6SUNzR3d0eEpkVkhFa2Z5ZjYxcGtxRUVBSnAxa2dvb1lhYTZ4eFVZRUEwczdoZkQ0czJzYTIwbW5NVzBtdXZRRVdtenp6djVQQXhVclZqdDlGUFhwT0ZNcUkyVEkzODROUEFhSmhMWm55eU1OT3JiY3JTelB3L3NFWitFbGNMa253ZmZNc3hRSzFSOVh2MFZ3cWxmdW1VUkhCeDFOelRiUjZ6WnIzclN1Vk5pNFFqcVNteDdTRkVRcjY2NGY2MUxwcTBwVk5DalNHMUxBdU00NmFMRWdaYktzQXNoTXNqNTFVTWU1dGxIS3RuVmorMkZNc3ZWTkJvZ1FzV3daUW1GdFhSakl0cEpSWERpd3YzSEhOV1diQlBwTzFJY1dNdVFKb3VxTk1ncDVWVVlWSW5GVWsxd2wvV3NySUE2SGFhelJrSVc4RlYvQ3U4OUV2RHFYZUJCcEhRa0lPR29rZXkrUlk1dW5xZkMvU2dndk1IRnE5VXRZUXVrbFJhWjlDdC9XcFFjS3BDRzNBU2FtTVM4QWRVbzlDZzdnc29mNTlVbzFOSEtML3BTRkxTRUZzTlltdmJsQnJwaGduTFN0cW5ET25hSTJ2MW12WTdYWjNQTHpUTXJ1ZkJoSDBCaWZHalUwdU5jR0Jlb2hvVWFFK1k5VVFlSUY2NFpwUGl6cTF1bmNiRGsyK0FXTS83QkRrQkxDOE1kS1hXNXZEMm5lL0QzdUVmTXVGM3c5cXFXSUM4c01qZzM5TkJVeHo5NDhIRTVlZTdqYy9MVG50eG5lODhNQ1dwNk14VVhlOXVnZGV2ajNCTkFXKzZrb0Z2VWhsejJMSHZKRDVoY2FkeTNjTExudHhSdXc1N0U2TGNOT2psTWhNeWhmbkdFV0NTTFNrcDJScllSYi9lWkdmeXpMWk0yLzZWVXZQdFVaaXI2dGh5UGpGekRkamY0SEJMTk9QdFJhT3lJRkhuU1pxUWdkU3QwSlNYbDBCR1NMd05EemxVRWFHU2Q5RUlzUkkxWUJvakw1bi84eFNuNytyeVFmMGpabXZUN1ZBcjVtTEgvempLbUlaRWJNWFJMMHZZemxiMjFRaG1iMWtkMW44RTVEYisvM0dzcFpTRnVMcTJBdkdXczF5Slh4aVZlQkRYdXNCWDE3dldYaGNYUjYrc3ljT3Z0L2UyL1VaQzNSRXFsaWgzalFzYk5CdS9tYWg3RGpEdXQ2UXlrNnBnZmo5Wk9iZEwrYzlHN2dCUUNIaUlhWHQzS1hiakZLTWpIN3ZUTFZmQnlyNDR1WUN1Ly94YWs2NHVuYUlWZCtkYm1oR2tDb0FzelNiOE5JZ0d4WUNJL3FKN3Rid0VLVXdKdzlBTFIwUHpmOXBaWDdrTSs2Vm12V3RqTjdSOFRYQWtHeHo0cUxLcFkwMnkxMVk5TkwyY2NFNWMzS2lqL0FJM0JvUVRETGlCWFIvSnNuVEFpTkoxdHl0amRvTXFxVVoxY3FxSExlUXNnT3FLT2tMWXNlVmRPN0pJYko2SGpmUjlPS2NNYXM3TVVHTnNSZThNV2s4QlUza0JxWUxRcEx3Q0dGSjM0b2pwWUtlcitENWZGQkdNc21EL1RMYTRadFA3eFpneS8vUEMzUC9OT2pDR0dHSFFJZz09IiwiZGF0YWtleSI6IkFRRUJBSGlqRUZYR3dGMWNpcFZPYWNHOHFSbUpvVkJQYXk4TFVVdlU4UkNWVjBYb0h3QUFBSDR3ZkFZSktvWklodmNOQVFjR29HOHdiUUlCQURCb0Jna3Foa2lHOXcwQkJ3RXdIZ1lKWUlaSUFXVURCQUV1TUJFRUREdDErQXl1NEkvMWlzYUswUUlCRUlBN2g1djZhbzFUYWUvSk9QR3pSclF2b0ZSNlhoeEszcFNZZHdOeVBKRitsbEZ3WWp3aUphM0ZsK2drbGozMnhMS1FUcHFDWlBTcU5VYzZGUTQ9IiwidmVyc2lvbiI6IjIiLCJ0eXBlIjoiREFUQV9LRVkiLCJleHBpcmF0aW9uIjoxNzEyNTgyOTQ1fQ=="
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