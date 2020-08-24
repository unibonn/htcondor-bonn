---
title: Accessing the test cluster
---
# Accessing the test cluster

The test cluster holds several submission nodes, a central manager and worker nodes. You will have received a username, password and a host name in the course
which you can use for logging in via SSH. 

On Linux and MacOS X, an OpenSSH client is usually installed by default.
In case you want X11 graphics (not required by the course), you need XQuartz on the Mac and use `ssh -X`.
In the course, it will also be necessary to copy files to your machine to look at them (pictures, videos). For this, you can use `scp` or `rsync`.

## Windows
On Windows, you can either use PUTTY, install a Linux distribution using the Windows Subsystem for Linux (WSL) via the Store,
or use Cygwin. 

If you want X11 graphics (not required by the course), you may use Xming for example in combination with WSL or Cygwin.
To make use of it, you may have to run:
{% highlight shell %}
export DISPLAY=localhost:0.0
{% endhighlight %}
in the terminal once before running `ssh -X`. 

In the course, it will also be necessary to copy files to your machine to look at them (pictures, videos). For this, you can use `scp` or `rsync`
inside WSL or Cygwin, or use a graphical tool like `WinSCP` natively on Windows.

## Preparing your environment
Several of the files mentioned in the course can be created manually (by copy-pasting from the page), but it is usually more easy to check out the repository.

You can do so by running:
{% highlight shell %}
git clone https://github.com/unibonn/htcondor-bonn.git
{% endhighlight %}
The repository will then be available in the directory `htcondor-bonn`.

{% include footer_exercises.html %}
