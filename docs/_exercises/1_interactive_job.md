---
title: An interactive job
---
# An interactive job

As explained in the [presentation]({{ site.baseurl }}/presentation/presentation.pdf), HTCondor is most prominently used from a personal desktop machine (for example at your workplace / institute). Sadly, software is often not developed for the system you can (or want) to use on your desktop machine.

To overcome this issue, containerization comes to the rescue and allows to select a different runtime environment for your computing job.
Of course, you still need a way to interactively develop and test your program. This is the point at which an interactive job comes in.

{% highlight shell %}
$ condor_submit -interactive -append '+ContainerOS = "CentOS7"'
Submitting job(s).
1 job(s) submitted to cluster 39.
Welcome to slot1_1@htcondor-t-wn-0!
You will be logged out after 7200 seconds of inactivity.
You requested 1 core(s), 512 MB RAM, 35 kB disk space.
{% endhighlight %}

The `append` parameter causes the given content to be appended to the job ClassAd. The special character `+` identifies this attribute as a custom attribute which, in our test cluster, selects the environment we want to use.

In the test cluster, we offer three different environments:

| Operating System   | Value of ContainerOS |
|:-------------------|:---------------------|
| CentOS 7.6         | CentOS7              |
| Scientific Linux 6 | SL6                  |
| Ubuntu 18.04 LTS   | Ubuntu1804           |

* * *

> :exclamation: Try to start an interactive job in each of them and check out your environment.

> :bulb: If you are affiliated with Linux, you may want to check which kernel version you see inside the job (`uname -a`) and run `lsb_release -a` or view the contents of the file `/etc/os-release`.

{% include footer_exercises.html %}
