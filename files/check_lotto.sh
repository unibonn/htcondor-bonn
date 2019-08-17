#!/bin/bash
source /etc/profile

CLUSTER_ID=$1

mkdir lotto_results
shuf -i 1-49 -n 6 > lotto_random.txt

for sheet in lotto_sheets/*.txt; do
		COR_NUMS=0
		for NUM in $(cat lotto_random.txt); do
				egrep -q "^${NUM}$" ${sheet} && COR_NUMS=$((COR_NUMS+1))
		done
		echo ${COR_NUMS} >> lotto_results/${CLUSTER_ID}.txt
done
