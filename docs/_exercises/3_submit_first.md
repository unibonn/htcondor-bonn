---
title: Submitting a first batch job
---
# A first batch job

With the knowledge on how to submit an interactive job, submitting a batch job is straightforward.
The main difference is that you need to specify an `Executable` to run, and should specify where to store output and logs.
In our first simple example, we will go with a batch script which shows some information about the environment inside the job.

We need two files:

> :exclamation: Save the following into a file of your choosing or use the file `CentOS7_simple.jdl` from the repository.
{% highlight shell %}
Executable = environment-info.sh
Arguments  = some Arguments for our program $(ClusterId) $(Process)
Universe   = vanilla

# Specify files to be transferred (please note that files on a shared filesystem should not be transferred!!!)
# Should executable be transferred from the submit node to the job working directory on the worker node?
Transfer_executable     = True

Error                   = logs/err.$(ClusterId).$(Process)
#Input                  = input/in.$(ClusterId).$(Process)
Output                  = logs/out.$(ClusterId).$(Process)
Log                     = logs/log.$(ClusterId).$(Process)

+ContainerOS="CentOS7"

Request_cpus = 2
Request_memory = 2 GB
Request_disk = 100 MB

Queue
{% endhighlight %}

> :exclamation: Save the following into a file of your choosing or use the file `environment-info.sh` from the repository.
{% highlight shell %}
#!/bin/bash
source /etc/profile

echo "Called with arguments:"
echo "$@"

echo "PATH variable:"
echo $PATH

echo "OS release:"
cat /etc/os-release

echo "Running in Condor Slot:"
echo ${_CONDOR_SLOT_NAME}

echo "Kernel version:"
uname -a

echo "Full environment:"
env

echo "Running processes:"
ps faux

echo "Directory content:"
ls

echo "Sleeping a bit..."
for num in {1..10}; do
  echo "Sleep iteration ${num}/10..."
  sleep 60;
done
{% endhighlight %}

> :exclamation: Please check that the shell script is executable - if not, run `chmod +x environment-info.sh`.

> :exclamation: Usually, you should test your code before. If a special environment is needed, you can do that in an interactive job, before firing off many jobs. In our case, just test the script on the submit node by running `./environment-info.sh` and check what happens.

> :exclamation: Now, you can finally submit the job:
{% highlight shell %}
$ condor_submit CentOS7_simple.jdl
Submitting job(s)
ERROR: Invalid log file: "/home/student00/htcondor-bonn/files/logs/log.44.0" (No such file or directory)
{% endhighlight %}
Please note that this fails!
HTCondor usually performs a check whether the log files and other output files can be written before
submitting the job. You can turn this off by adding `-disable` to the call to `condor_submit`, which speeds up submission - but then
the jobs will go into `HOLD` state in case the files can not be written on the submit node. 

So you will want to fix the problem:
{% highlight shell %}
mkdir logs
{% endhighlight %}
Now, please try again:
{% highlight shell %}
$ condor_submit CentOS7_simple.jdl
Submitting job(s).
1 job(s) submitted to cluster 46.
{% endhighlight %}

> :exclamation: Now, you can investigate the job a bit. Some examples follow.

1. Use `condor_q`.
2. Check out some more details with `condor_q -long clusterid.process`.
3. Check out the files inside the `logs` directory.
4. Try to follow along the job output using `condor_tail -f clusterid.process`.

> :question: Especially at this point, you are invited to ask questions about what you find!

* * *

## Removing jobs

> :bulb: Take note of the possibility to remove jobs, for example when you are finished with your investigations or have found a bug and want to re-submit!

To remove a full cluster of jobs:
{% highlight shell %}
condor_rm clusterid
{% endhighlight %}
To remove a single job:
{% highlight shell %}
condor_rm clusterid.process
{% endhighlight %}
To remove all your jobs:
{% highlight shell %}
condor_rm username
{% endhighlight %}

> :exclamation: Submit another one of your test jobs and remove it. How long does it take? Check the status with `condor_q` during the process.

{% include footer_exercises.html %}
