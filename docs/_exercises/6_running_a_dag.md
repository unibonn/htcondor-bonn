---
title: Running a DAG
---
# Running a DAG

HTCondor's DAGMAN functionality allows to express complex dependencies between jobs.
In our simple example, we will do a video render: We will first have a lot of jobs each of which renders a single frame,
and finally, we have one job creating an output video from the frames. 

For this, we will again use the open source renderer [POV-Ray](http://www.povray.org/) (Persistence of Vision Raytracer),
and also make use of the two scenes already used in the previous exercise (the attribution to the artists can be found there and with the artwork).

Again, we need a file to describe our job, and an actual job payload, per job.
However, we are now running two different kinds of jobs: The first type of job does the image rendering,
the second type of job takes the produced images and creates a movie file from them.

## The first kind of job: Image rendering

This job is actually very similar to the job we used in the previous exercise. The only added parts are some different quality settings
to speed up the rendering, and the actual animation.

> :exclamation: Save the following into a file of your choosing or use the file `Ubuntu1804_render_movie_frames.jdl` from the repository.
{% highlight shell %}

{% endhighlight %}

> :exclamation: Save the following into a file of your choosing or use the file `render_pov_movie.sh` from the repository.
{% highlight shell %}

{% endhighlight %}

> :exclamation: Please check that the shell script is executable - if not, run `chmod +x render_pov_movie.sh`.

## The second kind of job: Creating the movie

> :exclamation: Save the following into a file of your choosing or use the file `Ubuntu1804_create_movie.jdl` from the repository.
{% highlight shell %}

{% endhighlight %}

> :exclamation: Save the following into a file of your choosing or use the file `create_pov_movie.sh` from the repository.
{% highlight shell %}

{% endhighlight %}

> :exclamation: Please check that the shell script is executable - if not, run `chmod +x create_pov_movie.sh`.

## The DAG file

Now, we need the final ingredient: A DAG file which describes the interdependencies between these kinds of jobs.
In the end, only this file will be submitted and take care of running the JDL files outlined before.

To reduce the computational effort, everybody should render only one movie at first (if there is time, feel free to submit the second!).
For this reason, two alternative DAG files are prepared:

> :exclamation: The first file has the following content and is available from the repository under the name `Ubuntu1804_render_movie_dice.dag`.
{% highlight shell %}

{% endhighlight %}

> :exclamation: The second file has the following content and is available from the repository under the name `Ubuntu1804_render_movie_mini_demo.dag`.
{% highlight shell %}

{% endhighlight %}

> :question: Please choose one of the two files. Can you explain the differences between the two?
> If it is not clear to you how the files interact, now is the right time to ask!

> :exclamation: Submit the job as follows and check what happens:
{% highlight shell %}
$ condor_submit_dag
FIXME
{% endhighlight %}

> :question: What is happening? Where do you expect to find files on your submit machine?

> :exclamation: Check the progress of your jobs, they will run for a while. The following commands and the log files may be useful (feel free to try them all!):
{% highlight shell %}
condor_q
condor_q -nobatch
watch -n 10 condor_q -nobatch
condor_q -nobatch -dag
condor_q -constraint 'JobStatus == 2' -af:hj Cmd ResidentSetSize_RAW RequestMemory DiskUsage_RAW RequestDisk
condor_history -constraint 'JobStatus == 4' -af:hj Cmd ResidentSetSize_RAW RequestMemory DiskUsage_RAW RequestDisk
condor_status
condor_status -avail -af:h Name Memory Cpus
condor_status -compact
condor_userprio
condor_userprio -allusers -all
{% endhighlight %}

> :leopard: Check out the man pages or the HTCondor documentation - can you find more interesting parameters?

> :leopard: You may want to play with priorities and resource requests for jobs which are still waiting in the queue (you can only rank your own jobs against each other!). Helpful commands could be (for cluster ID 72):
{% highlight shell %}
condor_q -af:hj JobPrio JobStatus
condor_prio -p 10 72.0
condor_qedit 72 -constraint 'JobStatus == 1' RequestMemory 400 RequestCpus 1
{% endhighlight %}

> :leopard: If you have been really attentive, you may have noticed that sometimes, the jobs do not run in the expected order - for example, you may see less render jobs running than cores are available,
> or movie creation jobs hanging in the queue even though there are free resources. Do you have an explanation why?
> <details><summary>Hint 1</summary>Check the resource requests of the two different job types carefully - is there a difference?</details>
> <details><summary>Hint 2</summary>You may remember about partitionable slots of HTCondor... how could they impact efficiency here?</details>
> <details><summary>Hint 3</summary>The test cluster uses the setting `CLAIM_WORKLIFE = 300`. Check the HTCondor documentation on the effects of this setting!</details>

## Check out your results

If all went well, you should find `render_results` and a final `.mp4` movie file. Copy them to your local machine to watch them.
How does the quality compare to the still images we rendered before?

{% include footer_exercises.html %}
