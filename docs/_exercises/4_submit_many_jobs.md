---
title: Submitting many jobs
---
# Submitting many jobs

In this example, we will focus on how to get input files into our jobs, and how to collect output.

Again, we need a file to describe our job, and an actual job payload.

> :exclamation: Save the following into a file of your choosing or use the file `Rocky8_lotto.jdl` from the repository.
{% highlight shell %}
Executable = check_lotto.sh
Arguments  = $(Process)
Universe   = vanilla

# Specify files to be transferred (please note that files on a shared filesystem should not be transferred!!!)
# Should executable be transferred from the submit node to the job working directory on the worker node?
Transfer_executable     = True

Error                   = logs/err.$(ClusterId).$(Process)
Input                   = lotto_sheets
Output                  = logs/out.$(ClusterId).$(Process)
Log                     = logs/log.$(ClusterId).$(Process)

Transfer_Output_Files   = lotto_results

+ContainerOS = "Rocky8"
+CephFS_IO   = "none"
+MaxRuntimeHours = 1

Request_cpus = 1
Request_memory = 1 GB
Request_disk = 10 MB

Queue 52
{% endhighlight %}

> :exclamation: Save the following into a file of your choosing or use the file `check_lotto.sh` from the repository.
{% highlight shell %}
#!/bin/bash
source /etc/profile
set -e
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
{% endhighlight %}

> :exclamation: Please check that the shell script is executable - if not, run `chmod +x check_lotto.sh`.

> :exclamation: As you may have guessed, we are going to play a small lottery game here. This simulates a weekly lottery, and 52 draws are done, a single one per job.
> Please create the directory `lotto_sheets` and prepare your lucky numbers in it.
> You should create at least one file with exactly 6 numbers (one per line) in it. The numbers should range between 1 and 49.
> Name the file with the extension `.txt`. You can also create multiple files if you have more than one set of lucky numbers.

> :exclamation: Submit the job as follows and check what happens:
{% highlight shell %}
$ condor_submit Rocky8_lotto.jdl 
Submitting job(s)....................................................
52 job(s) submitted to cluster 51.
{% endhighlight %}

> :question: What is happening? Where do you expect to find files on your submit machine?

## Check out your results
Ignoring any special rules, you basically win something if at least 3 numbers were guessed correctly.
Did you win something?

> :exclamation: Check out your result files:
{% highlight shell %}
cat lotto_results/*.txt | sort -n | uniq -c
{% endhighlight %}
> :question: What exactly does this command show? If in doubt, please ask!

{% include footer_exercises.html %}
