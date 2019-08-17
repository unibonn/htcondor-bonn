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
Arguments  =
Universe   = vanilla

# Specify files to be transferred (please note that files on a shared filesystem should not be transferred!!!)
# Should executable be transferred from the submit node to the job working directory on the worker node?
Transfer_executable     = True

Error                   = logs/err.$(ClusterId).$(Process)
#Input                  = input/in.$(ClusterId).$(Process)
Output                  = logs/out.$(ClusterId).$(Process)
Log                     = logs/log.$(ClusterId).$(Process)

+ConainerOS="CentOS7"

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
{% endhighlight %}

> :exclamation: Now, you can finally submit the job:
{% highlight shell %}
$ condor_submit CentOS7_simple.jdl
Submitting job(s).
1 job(s) submitted to cluster 41.
{% endhighlight %}


{% include footer_exercises.html %}
