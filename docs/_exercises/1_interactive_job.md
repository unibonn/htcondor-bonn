---
title: An interactive job
---
# An interactive job

As explained in the [presentation]({{ site.baseurl }}/presentation/presentation.pdf), HTCondor is most prominently used from a personal desktop machine (for example at your workplace / institute). Sadly, software is often not developed for the system you can (or want) to use on your desktop machine.

To overcome this issue, containerization comes to the rescue and allows to select a different runtime environment for your computing job.
Of course, you still need a way to interactively develop and test your program. This is the point at which an interactive job comes in. 

{% highlight shell %}
$ condor_submit -interactive -append '+ContainerOS = "Rocky9"' -append '+CephFS_IO = "none"' -append '+MaxRuntimeHours=12'
Submitting job(s).
1 job(s) submitted to cluster 39.
Welcome to slot1_1@wn001!
You will be logged out after 7200 seconds of inactivity.
You requested 1 core(s), 512 MB RAM, 35 kB disk space.
{% endhighlight %}

:bulb: You will surely note that this commandline is quite lengthy. We will learn a better way in the next section exercise.

The `append` parameter causes the given content to be appended to the job ClassAd. The special character `+` identifies this attribute as a custom attribute. There are several special attributes we require for jobs in Bonn, which we will describe now in detail. Note other clusters may have different special attributes (or none at all), since HTCondor can be extended as required for cluster operations and user requirements.

Note that specifying extra attributes on a cluster not supporting them will usually have no effect --- they will just not be evaluated.

## `ContainerOS`
This specifies the environment you want to use. We use the latest upstream base images and extend them with site-specifics and software either asked for by users or required by experiments. We offer several of these:

| Operating System   | Value of ContainerOS |
|:-------------------|:---------------------|
| CentOS 7           | CentOS7              |
| Rocky Linux 8      | Rocky8               |
| Rocky Linux 9      | Rocky9               |
| Debian 10          | Debian10             |
| Debian 11          | Debian11             |
| Debian 12          | Debian12             |
| Ubuntu 20.04 LTS   | Ubuntu2004           |

## `CephFS_IO`
This specifies how much IO the job will perform to the cluster filesystem. There are several possible values:

| Value    | Meaning              |
|:---------|:----------------------------------------------------------------------|
| "high"   | maximum throughput to CephFS needed (via 56 GBit/s InfiniBand)        |
| "medium" | less throughput needed (e.g. storing simulation output, via Ethernet) |
| "low"    | low throughput needed (only status, smaller text files are read from or written to `/cephfs`) |
| "none"   |your job does not access `/cephfs` at all                              |

## `MaxRuntimeHours`
This specifies how long the job is allowed to execute (in hours). A flag like this is often added as a special attribute to HTCondor clusters, since it allows to steer jobs to different nodes depending on their runtime (imagine a scheduled maintenance or a planned reboot for updates, for instance, or opportunistic resources only available for a limited time). In our case, this number is limited by job type:

| Job Type        | Maximum runtime limit    |
|:----------------|:-------------------------|
| Batch Job       | up to 7 days (168 hours) |
| Interactive Job | up to 24 hours           |

* * *

> :exclamation: Try to start an interactive job with different `ContainerOS` settings and check out your environment.

> :bulb: If you are familiar with Linux, you may want to check which kernel version you see inside the job (`uname -a`) and run `lsb_release -a` or view the contents of the file `/etc/os-release`.

> :exclamation: Try to specify an unexpected / bad value for `CephFS_IO` or `MaxRuntimeHours`. What happens when you try to submit the job?

> :bulb: Note that when you submit with a bad value for `ContainerOS`, your job will wait in the queue until a machine offering this `ContainerOS` appears, which does never happen for a bad value.

{% include footer_exercises.html %}
