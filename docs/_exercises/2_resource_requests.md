---
title: Resource Requests
---
# Resource Requests

You may have noticed the line:
{% highlight shell %}
You requested 1 core(s), 512 MB RAM, 35 kB disk space.
{% endhighlight %}
in the interactive job example.

> :leopard: You may want to check out where this output is generated.
> <details><summary>Hint 1</summary>It is <b>not</b> created by HTCondor itself, but in your environment.</details>
> <details><summary>Hint 2</summary>Check out `/etc/profile.d`.</details>
> <details><summary>Hint 3</summary>Check out `/etc/profile.d/12-resources_and_mt.sh`. How does it gather the information?</details>

These are default resource requests which can be configured as part of the HTCondor configuration on the submission machine. In case different resources are required, you should specify these.

However, adding more and more parameters to `condor_submit -interactive` is not really feasible. To define your requests, it is easier to create a file containing these requests and hand that to `condor_submit`. In our course, we commonly use the file exension `jdl` to indicate the file is written in the `job description language` (which is basically just a collection of attributes being merged into the Job ClassAd).

An example could be the following:

{% highlight shell %}
JobBatchName = SL6_interactive
+ContainerOS = "SL6"
Request_cpus = 2
Request_memory = 2 GB
Request_disk = 100 MB
Queue
{% endhighlight %}

> :exclamation: Save this into a file of your choosing or use the file `SL6_interactive.jdl` from the repository, and submit it as shown here:
{% highlight shell %}
$ condor_submit -interactive SL6_interactive.jdl
Submitting job(s).
1 job(s) submitted to cluster 40.
Welcome to slot1_1@htcondor-t-wn-0!
You requested 2 core(s), 2048 MB RAM, 102400 kB disk space.
{% endhighlight %}

## Best practices

| :+1: | HTCondor file transfer may be used to get credentials into the job (e.g. SSH keys).[^1] |
| :+1: | HTCondor will tell you about used resources after a job has finished[^2] |
| :-1: | Mismatched resource requests lead to resource underuse or congestion (both are inefficient). This usually badly affects also other users' jobs! |
| :-1: | A large number of jobs should be submitted in batch mode and not interactively. Commonly, computing centres reserve dedicated slots to guarantee availability of interactive resources. |
| :-1: | Interactive jobs should not be left running excessively long - they are meant for debugging or interactive processing, and are not "login shells". |

[^1]: Most clusters have a shared file system. However, permissions are usually more "loose" there, so placing credentials on it and securing access needs care.
[^2]: An exception to that is (currently) the used swap space, if the cluster allows you to use swap.

{% include footer_exercises.html %}
