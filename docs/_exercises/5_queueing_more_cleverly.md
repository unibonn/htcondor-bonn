---
title: Queueing more cleverly
---
# Queueing more cleverly

Often in scientific analyses, you will face the problem that you have a large number of differently named output files and you want to analyze them
crunching through one file per job. Up to now, we have only used a basic `Queue` command, queueing multiple jobs with different process IDs.
But HTCondor can also help out in the common use case where file names or more complex configuration sets need to be queued.

In our simple example, we will render some 3D images: We have two rather complex scenes whose files live in separate directories.

For the rendering, we will use the open source renderer [POV-Ray](http://www.povray.org/) (Persistence of Vision Raytracer).
Since well-made 3D objects are better made by people with more artistic sense than the regular HTCondor user,
I have used existing artwork available under the
[Creative Commons Attribution-Share Alike 3.0 Unported](http://creativecommons.org/licenses/by/3.0/) ![CC-BY-3.0](https://creativecommons.org/images/public/somerights20.gif) license. 

Hence, we start with an attribution to the artists:

* * *

The artwork available as "dice" in this course was made available under [Creative Commons Attribution-Share Alike 3.0 Unported](http://creativecommons.org/licenses/by/3.0/) ![CC-BY-3.0](https://creativecommons.org/images/public/somerights20.gif).
The artwork is called "PNG transparency demonstration"" and has been shared by user [ed_g2s](https://commons.wikimedia.org/wiki/User:Ed_g2s) on Wikimedia at [https://commons.wikimedia.org/wiki/File:PNG_transparency_demonstration_1.png](https://commons.wikimedia.org/wiki/File:PNG_transparency_demonstration_1.png).

For the course, I have added an additional file `dice_movie.pov` and a `render_movie.ini` which chooses some more light settings for creation of a movie. In addition, a `render.ini` file has been added to render a simple frame.

* * *

The artwork available as "mini_demo" in this course including the scene and all materials were made available under [Creative Commons Attribution-Share Alike 3.0 Unported](http://creativecommons.org/licenses/by/3.0/) ![CC-BY-3.0](https://creativecommons.org/images/public/somerights20.gif).
The artwork is called "Mini Cooper and Building" and has been shared by &copy; 2004 Gilles Tran [http://www.oyonale.com](http://www.oyonale.com).

For the course, I have added an additional file `demo_mini_movie.pov` and a `render_movie.ini` which chooses some more light settings for creation of a movie. In addition, a `render.ini` file has been added to render a simple frame.

* * *

Again, we need a file to describe our job, and an actual job payload. We will use a flexible job payload
(a shell script taking parameters) and use a single job description file for all scenes.

> :exclamation: Save the following into a file of your choosing or use the file `Ubuntu1804_render_scenes.jdl` from the repository.
{% highlight shell %}
FIXME
{% endhighlight %}

> :exclamation: Save the following into a file of your choosing or use the file `render_pov_single.sh` from the repository.
{% highlight shell %}
FIXME
{% endhighlight %}

> :exclamation: Please check that the shell script is executable - if not, run `chmod +x render_pov_single.sh`.

> :exclamation: First, take a look at the job description file. Can you understand how it works? Some helpful pointers follow.

In general, fi syntax is unclear, you may want to check out the HTCondor documentation.
In the course, we are using version `8.6.13` (there are still bugs in more recent versions concerning execution of Singularity containers). You can check that with `condor_q -version`.

For example, to get an explanation on what the strange magic line `Scene = $Fdb(ScenePath)` is doing, it is best to start from the [HTCondor web page](https://research.cs.wisc.edu/htcondor/),
since links to the HTCondor documentation are sadly not stable yet[^1].
As you might guess, `$Something()` is the syntax of a built-in function. You will find it explained in chapter 3.3.10. 

> :question: Can you find out what it does, and why might we need it? To answer this question, you should also understand the `Queue` command. If in doubt, this is the right point in time to ask!

> :exclamation: As soon as everything is understood and you know what to expect, it is time to submit the jobs:
{% highlight shell %}
$ condor_submit Ubuntu1804_render_scenes.jdl
FIXME
{% endhighlight %}

These jobs may run for a little while, so let's take the time to check on them! POV-Ray produces some progress output on `STDERR`. You can access that live from your submit machine using:
{% highlight shell %}
condor_tail -no-stdout -stderr -f 66.0

FIXME
{% endhighlight %}

You can also check the `log` file of the job, and use `condor_q` to check resource usage:
{% highlight shell %}
$ condor_q -af:hj Cmd ResidentSetSize_RAW RequestMemory RequestCPUs DiskUsage_RAW RequestDisk Owner RemoteHost
{% endhighlight %}

> :exclamation: Check out status and resource consumption of those jobs. Do they match with the requests formulated in the job description?

## Check out your results
As soon as the jobs have finished, you should find two new image files in your submit directory.
The best way to look at them is to copy them to your local machine (on Linux or MacOS X, use `scp` or `rsync`, on Windows, either use the same commands in Windows Subsystem for Linux (WSL),
or use e.g. WinSCP). Once they have arrived, use a normal image viewer. 

[^1]: A very much improved online documentation is part of the HTCondor 8.8 series.

{% include footer_exercises.html %}
