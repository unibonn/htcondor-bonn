---
title: Accessing the cluster
---
# Accessing the cluster

All desktop nodes are submission nodes. Additionally, we operate two central managers in a high availability setup and many worker nodes. You will have a "Uni-ID", password and know how to access a desktop machine via SSH when arriving here.

On Linux and macOS X, an OpenSSH client is usually installed by default.
In case you want X11 graphics (not required by the course), you need XQuartz on the Mac and use `ssh -X`.
In the course, it will also be necessary to copy files to your machine to look at them (pictures, videos). For this, you can use `scp` or `rsync`.

## Windows
On Windows, you can either use PUTTY, install a Linux distribution using the Windows Subsystem for Linux (WSL) via the Store,
or use Cygwin. With recent Windows 10 releases, you will also have an SSH client readily available on the command line which you can use. You may also be interested in installing the "Windows Terminal" app via the store.

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
