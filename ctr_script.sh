#!/bin/bash -e
set -e
echo "3gb-3-layer-no-concurrency-no-parallelism" >> results.json
# sudo touch token.txt
# echo "aws ecr get-login-password --region us-west-1" >> token.txt
# cat token.txt

echo "[ {" >> results.json 
# for i in $(seq 1 4); do
for j in $(seq 1 10); do
  # >&2 echo "Run: $j with parallel arg: $i"
  ECR_PULL_PARALLEL=0
  >&2 sudo service containerd stop
  >&2 sudo rm -rf /var/lib/containerd
  >&2 sudo mkdir -p /var/lib/containerd
  >&2 sudo service containerd start
  CGROUP_PARENT="ecr-pull-benchmark"
  CGROUP_CHILD="count-$j-parallel-${ECR_PULL_PARALLEL}-slice"
  CGROUP=${CGROUP_PARENT}/${CGROUP_CHILD}
  IMAGE_URL="020023120753.dkr.ecr.us-west-1.amazonaws.com/1gb-single"
  TOKEN="eyJwYXlsb2FkIjoibjZwN2paaFp5dFZZS21yZllseEQ1RnQyVExLRU9aSG5PWkNZamt1VW1yM21takc4VXNVZkVrVHFJQXhWYSsyeDI3SEZCbjF4azNrUjJ3Z1UwUWtkaGRGVHQwUCt3dFJENUt5d3hLN2ZBckROU2V5Nm5sMjZrRWU4V3Frbk9JLzR5d04yWHFFcVpPOVM3SDdCTFVMd09XbzNseitNNTRudU9Tb1Nram1XSFIwT3hUand3eXl5eFVQeHJLRmYzRlRkOEZtL3laSVJrY3ZDYzlmS3J3TjBsL09tRjI1dWo0T1Q4YlY5aWsrMm1pdlNBNWN0d2V0Y0kvU29XUktmclgrZkVqTmpjdFQ4Mk5uRjM0QjBZbG9zcEhURmtYaDdiaVFjODNDRE9VOTlYeTEyelloWS9sOWhOcDNLOTFCc0JxYlF3ZFNYbGVZVjN4eTZJRVJpRWdRNkIrMlhWL0VvZCtpWlcrUWtKQktCYVBEUE9ldy9taVJKK3crRVNJVDUzNDJjbEl1aDQ4Q016YjBobEwrTkhqTmlaTzZmdklmN0tqMzFwc0pINmdJL2N1c1ZIaXFzcmt6QWpXYWtFTDkzVk1WZnBYMTFVM1VtL29TVXM5cGhvMlNqYUNjUjg1TWZhU1J0ZE1TMjhSMkdZU0R2d0NFZCtwQlBHVEhuRVNiUTE2UUhQZHo3bEJmUCtOdExtQmY1Wktmb21sRkJvb1dqR25UemdoQld2b3VpZzJKSFJ2dmFLa2lHTDhsN2dBZHBuQlVZcjRoQlRteDgxbnRqYmp5SkxsWTlmNHY1dWg1QzhWRDVkdW5zc01QTTBHdWJiaDlzVm9EK000RGtQcjVCRDlaVGFoRXNidjNueG5jWGtiZmRLZjEvK2ExS3RURkxmZllzaFE0NmovNEN3di9ZWmNwQVZiaDFackcyR3FoNTlaalllNk9QdDJWdzhwSkMwSFM5aFZGSlRJdlR0K1VMekhvZWZRODFuK3RMclVPWjFuSitPL1ZKWEV1WVV5dkhDdE5vM2pkSk1ySXA3Q1VpV1g2VHRCaUlWQXFLZlhERU1ETzFWMTlaSXdKK2JUQk1oUHpkV0N0ZWtPOEppL0dxOWVxS2djSGNlNzUzcWxhZmlYZGMxNTRTRjFJT01DWFRaWUVBcUNnallSS2RjRE40L1p1MVNYUzZuY3U1TWRKQU5kMTRwN0laVDlEb3JnZHRrclB6c0RZdWhhUE0zbDVGd0greXFjZjlJaDFNWHhQSXZ4Q2cra1FhU0ZpUnlNbmtrZDA3YmNYRnI2ZW9xUzEybk1KVGhlanNlVXlsMVNTNnZ6dTBVTHRaOFI2L2hIUHZmZS9MVVA3V1BIRjdYZGZqYmpEYWg3elhieEdkNVJHU3dpQ1pBaDNVejZqUW5wb2czUFFWV2Z2dGtBY2NzbTJOWjVWeFZMRkRjdWFsOGsyQzRwRWZHSk03V0lmUFY1Z0dGUGVId1hCU0E2UXNNcWMybFp4TzQ1YVFTMlZ6MkxiTjdMOVNGWms3WG8vNklmdVlvd0FUNEtpS1FsT3pOWWdoSVk4b3E0dldQSE92bS9kZzg4Y2ZBZlg0cGVmM21GQ1ExWGwwd3BEa1kxWFV5NllScEpvcUhJVmwzSU9aUlE0WTFQQmx4UkFQRDc3NWdZZmk3SGFLbC9OQUtVdEl3dHRiLzJ0aUlVWk5NdzMzdzVvOHVKaWYyUUk0aGt0WGN1cTNSdDZpS1NsbGhFZUhDOUtta0VYbGE0anBGSFJZQ0VqYk16YVVlSGV4SUdsTG5IdkJPV2xXSDJxQjNqanVZSEpBd2NBblhWZW1UVG5yY0ZXbE9sZDB6RmFyelVHanIzNm4zcXNTR3NPTWRUZy82c0UvSW42QVZZMUxacDlGMkxKY1YwQVJmU2JTVnhaZ3I1elJJWVkxcVBqaER4YkFsREJoUURGbEN6dCt4K1lnNHJBZkdvYlVhbDdYWGhLOWwxcHJ1TnJaVW1KbFVWclJsUkxaR0RLdG1hWDRGdnJJZWdUandwckU1VWMyOUpHRjBOWUlTOHd6WVVZZDdvVVFoc0oxbmVjMGtMdlV4YWVpQmdBUkcyeEp5ZnYvMmlkYzY0NHVvSmw2NlFRN2Jzd1VHVkdyRnkyUGdGR2o4Qm5EcnRVTzNJeWtwYXRkNXN2dmJtVzdUOXd2TWcvSlpnL1NxRjdlVmZXUVFaa1lQYUlPalRyL2syVEhIQ3Nqbm9kRjVvdEdQYUV4YjZycTg4czNYZERtaVpweDluVVM4b3ZQdnJkVUxmWnA1N3pvaVFFbUJzNDB2cnN0aGxPcmZMZU44Q1NQYVpuVmY5TmJNM3JXbkxHSGJJT0k3cnZjb0dtT1Q2R2orVVBUcVV1MW9xRmRpV3BTYlFPYlJOU3daRVpvVWgrbmJ4VzJyNHlLL3BrQ2Q5ZXpaei9qVjFFOHdWWmIrelNrK0FOejNReDB6d0RsMEpQTmJKRWZ1OW9adlZyVGdremVSQlhPSGFUajdjQ25sQ1VYTjBwakRtZVZkL2ppY3RQYmc4UytycGw5UEZlR1JwMjJienNkZnFDT0x0Tk16em42NGJ3MERWNWxicXlHRFlydSIsImRhdGFrZXkiOiJBUUVCQUhpakVGWEd3RjFjaXBWT2FjRzhxUm1Kb1ZCUGF5OExVVXZVOFJDVlYwWG9Id0FBQUg0d2ZBWUpLb1pJaHZjTkFRY0dvRzh3YlFJQkFEQm9CZ2txaGtpRzl3MEJCd0V3SGdZSllJWklBV1VEQkFFdU1CRUVESkZXSkRzNFBEc2xGUGJpdUFJQkVJQTdDTGxzaWRIWVN6MlM5NHlJbjkwT05ObFcvL3ovMjFsYnJ0VEFPL3pTRFFLMlQrZjlreC92NHZiTzc1NDRscFdUT05qbjNKWEN4QTlqLzRrPSIsInZlcnNpb24iOiIyIiwidHlwZSI6IkRBVEFfS0VZIiwiZXhwaXJhdGlvbiI6MTcxMTY4OTkwNX0="
  sudo ctr i rm ${IMAGE_URL}
  sudo mkdir -p /sys/fs/cgroup/${CGROUP}
  sudo echo '+memory' | sudo tee /sys/fs/cgroup/${CGROUP_PARENT}/cgroup.subtree_control
  sudo echo '+cpu' | sudo tee  /sys/fs/cgroup/${CGROUP_PARENT}/cgroup.subtree_control
  OUTPUT_FILE="/tmp/${CGROUP_CHILD}"
  sudo ./test.sh ${CGROUP} ${OUTPUT_FILE} sudo ctr images pull --user "AWS:${TOKEN}" ${IMAGE_URL}
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
    \"Memory\": $(( ${MEMORY} / 1024 ))
  }," >> results.json
  sudo rm ${OUTPUT_FILE}
  sudo rmdir /sys/fs/cgroup/${CGROUP}
done
 echo "} ]" >> results.json
