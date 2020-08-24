# Introduction to HTCondor

This tutorial is mostly a generic HTCondor introduction with some site-specifics for Uni Bonn. It originated from a tutorial given at [GridKa School 2019](https://indico.scc.kit.edu/event/460/contributions/5480/) and will try to answer the question:

> How to distribute your compute tasks and get results with high performance, keeping machines and site admins joyful?

The documentation on this page is part of [this repository]({{site.github.repository_url}}) which also contains files used in the part of the course.

## Structure

The tutorial is started with an [introductory presentation](presentation/presentation.pdf) and complemented by this very documentation and files provided in the [repository]({{site.github.repository_url}}).

The following outline links to the various exercises of the course.

### Outline

<ol>
{% for exercise in site.exercises %}
  <li><a href="{{ site.baseurl }}{{ exercise.url }}">{{ exercise.title }}</a></li>
{% endfor %}
</ol>

### Explanation of common icons

:exclamation: This marks a task.

:bulb: This marks extra information, or things you may want to investigate to learn some more details.

:question: This highlights a good point to ask questions if something is unclear. Of course, you can ask at any point!

:leopard: This marks bonus tasks for those who are faster than their colleagues.

:+1: Good practice.

:-1: Known (often common) bad practice.


### Licensing

There are two directories of the repository shared under a different license than the rest of this tutorial:

- `files/povray/mini_demo`
- `files/povray/dice`

These are shared under [Creative Commons Attribution-Share Alike 3.0 Unported](http://creativecommons.org/licenses/by/3.0/) ![CC-BY-3.0](https://creativecommons.org/images/public/somerights20.gif).
Detailed attribution is given in the `README.md` inside each folder, and during the course when the artwork is used.
