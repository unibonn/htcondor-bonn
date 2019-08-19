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
JobBatchName = Ubuntu1804_render_scenes
+ContainerOS = "Ubuntu1804"

Scene = $Fdb(ScenePath)

Executable=render_pov_single.sh
Arguments = $(Scene)

Transfer_input_files = povray/$(Scene)
Transfer_output_files = $(Scene).png

Error                   = logs/err.$(ClusterId).$(Process)
Output                  = logs/out.$(ClusterId).$(Process)
Log                     = logs/log.$(ClusterId).$(Process)

Request_cpus = 4
Request_memory = 1000 MB
Request_disk = 100 MB

Queue ScenePath matching dirs (povray/*)
{% endhighlight %}

> :exclamation: Save the following into a file of your choosing or use the file `render_pov_single.sh` from the repository.
{% highlight shell %}
#!/bin/bash

source /etc/profile

SCENE=$1

cd ${SCENE}
povray +V render.ini
mv ${SCENE}.png ..
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
Submitting job(s)..
2 job(s) submitted to cluster 98.
{% endhighlight %}

These jobs may run for a little while, so let's take the time to check on them! POV-Ray produces some progress output on `STDERR`. You can access that live from your submit machine using (with `98.0` being the first job's id):
{% highlight shell %}
$ condor_tail -no-stdout -stderr -f 98.0
Rendered 105472 of 480000 pixels (21%)
{% endhighlight %}
You can also ask for more output with:
{% highlight shell %}
$ condor_tail -no-stdout -stderr -maxbytes 100000 -f 98.0
...
Rendered 105472 of 480000 pixels (21%)
{% endhighlight %}

You can also check the `log` file of the job, and use `condor_q` to check resource usage:
{% highlight shell %}
$ condor_q -af:hj Cmd ResidentSetSize_RAW RequestMemory RequestCPUs DiskUsage_RAW RequestDisk Owner RemoteHost
 ID      Cmd                                                                    ResidentSetSize_RAW RequestMemory RequestCPUs DiskUsage_RAW RequestDisk Owner     RemoteHost             
  98.0   /home/student00/gridka-school-2019-htcondor/files/render_pov_single.sh undefined           1000          4           7             102400      student00 slot1_1@htcondor-t-wn-0
  98.1   /home/student00/gridka-school-2019-htcondor/files/render_pov_single.sh undefined           1000          4           53064         102400      student00 undefined
{% endhighlight %}

> :exclamation: Check out status and resource consumption of those jobs. Do they match with the requests formulated in the job description?

## Check out your results
As soon as the jobs have finished, you should find two new image files in your submit directory.
The best way to look at them is to copy them to your local machine (on Linux or MacOS X, use `scp` or `rsync`, on Windows, either use the same commands in Windows Subsystem for Linux (WSL),
or use e.g. WinSCP). Once they have arrived, use a normal image viewer. 

## Queueing with a complex set of parameters

Finally, you may encounter very complex analysis tools in your scientific career which need a lot of configuration parameters.
We don't provide a hands-on example here, since the possibilities are endless, but instead, we present an example snippet of a JDL file and configuration file
to queue a complex set of jobs. At this point, it is important to remember about the possibilities you are granted by HTCondor -
an actual implementation will always be specific for the analysis tool you are using.

Consider the following lines from a JDL:
{% highlight shell %}
Executable = myWrapperForAComplexAnalysisTool.sh
Arguments  = $(Process) $(INPUT_FOLDER) $(DATASETS) $(OUTPUT_FOLDER) $(MIN_CONFIDENCE)

if $(Debugging)
  slice = [1:]
  Arguments = -v $(Arguments)
endif

# Submit jobs as defined in input file
Queue INPUT_FOLDER DATASETS OUTPUT_FOLDER MIN_CONFIDENCE from $(slice) list_of_tasks.txt
{% endhighlight %}
and the following `lists_of_tasks.txt` accompanying it:
{% highlight shell %}
/clusterfs/user/myself/input/HIGGS/ AOD.07709524._000062.pool.root.1;AOD.07709524._000063.pool.root.1;AOD.07709524._000064.pool.root.1 /cephfs/user/freyermu/output/HIGGS/ 0.23
/clusterfs/user/myself/input/HIGGS/ AOD.07709524._000023.pool.root.1;AOD.07709524._000024.pool.root.1;AOD.07709524._000025.pool.root.1 /cephfs/user/freyermu/output/HIGGS/ 0.13
# ...
{% endhighlight %}
The several "columns" (separated by spaces) are identified as the variable names passed to the `Queue` command.
Note that the `DATASETS` column contains a list of datasets separated by `;` which may for example be parsed by the wrapper script or the analysis software.
This may for example be helpful if job runtime would otherwise be very short, and the actual setup / teardown phase would take long compared to the job runtime.
Examples for necessary, but heavy setup / teardown could be:
* Condor file transfer of large / huge number of input files
* Extraction of the actual software (for example, it might be stored as a tarball on a cluster file system, and be extracted on scratch space for actual use, since cluster file systems scale bad with many small files)
* Cleanup of the job scratch directory (this also takes time!)
* Necessary cache filling, software startup time etc.

:question: Can you follow along the example, and understand all parts of it? For example, what happens when you would name the full JDL file `analysis.jdl` and submit as follows?
{% highlight shell %}
condor_submit 'Debugging=true' analysis.jdl
{% endhighlight %}
:question: Do you have an example use case in mind? Feel free to ask questions!

[^1]: A very much improved online documentation is part of the HTCondor 8.8 series.

{% include footer_exercises.html %}
