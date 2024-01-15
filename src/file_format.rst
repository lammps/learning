.. _file-format:

================================
Introduction to the file formats
================================

LAMMPS internally keeps track of the evolution of atomistic systems. Such a
system is described as a `simulation box` containing an ensemble of particles
interacting with one another according to set of rules, and each with their own
position, velocities etc.

In this section, you will learn how to create a very simple simulation box
using LAMMPS built-in tools.

Running a minimal LAMMPS input
------------------------------

In an empty directory, open a text file and copy the following text inside:

.. code-block:: LAMMPS

   lattice sc 1.
   region box block 0 5 0 5 0 5
   create_box 1 box
   create_atoms 1 box

   mass 1 1

   write_data data.lmp
   write_dump all atom dump.lammpstrj

Let's save the file with the name `in.lmp`. Now in the command-line you can
run the following command to execute LAMMPS with this input:

.. code-block:: bash

   lmp -i in.lmp

You should see a bunch of lines appear in your screen. The first one should start
with `LAMMPS` followed by a parentheses with the specification of the version
of the code you are using. The last line should read something like
`Total wall time: 00:00:00`. If you've never executed LAMMPS before,
congratulation! This is maybe your first successful (very simple) simulation!

You will also notice that two files appeared in the directory: `data.lmp` and
`dump.lammpstrj`. Let's start by opening the first one.

Data file format
****************

The first file of the two is usually referred to as a `data file`. Its format
is rather strict, containing:
* a "header" block, which must come first in the file, and
* several "data sections", each of which:
  * starts with a capitalized keyword (such as "Atoms" or "Velocities")
  * followed by a blank line
  * and then a block of numbers (such as each atom's ID, x, y, and z velocities in "Velocities")

Let's slowly go through all of this.

The first part of the file is called `the header`. The first line of the file
is always a comment that LAMMPS does not read but which can contain
information on the way the file was generated. Here we see the LAMMPS version
and some more information like timestep and units. The following lines contain
the number of `atoms` (125), the number of `atom types` (1) and three lines
containing `xlo xhi` like indications. This header is simple, but generally,
headers can contain much more information. The first two lines are explicit,
you define a system with 125 atoms all of which have the same characteristics.
They all have the same characteristics because your simulation has only one `atom type`;
you will soon learn how to specify different interactions between particles
in LAMMPS by giving the particles different atom types.
The last three lines define the volume in which these atoms are contained. It
is a box with edge coordinates starting at 0 and ending at 5 in every direction
(x, y and z).

From here starts the body of the file. The order of the sections is not important
but all of them must come in the format:

.. code-block:: LAMMPS

   Section name # Capitalized, correctly spelled
   # blank line
   Section input # Number of line and format depend on the section.

The first section you should see is the `Masses` section. In LAMMPS, masses are
assigned to atom types so you only have one line here. All types have their own
masses but several types can have the same mass. Types are LAMMPS way to refer
to properties of particles that are *the same* for all particles of *the same
type*. They are also used to determine how particles interact with one another.
Types are not always binded to chemical species and you will see in further
tutorials how it can be convenient to define different types for similar atoms.

The `Atoms` section contains 125 lines, one per atom. The number on each line
are ordered and are for each particle:
* The particle ID which LAMMPS uses to refer to that particle internally
* The type of the particle
* The x, y and z coordinates in absolute distance value
* The xflag, yflag and zflag values, which you can put aside for now

Below you can also see the `Velocities` section which also contains 125 lines.
Each lines gives the particle ID followed by the instantaneous velocities of
the particles along the x, y and z axis in that order. The particle ID refers
to the same ID as in the `Atoms` section.

The format and meaning of the number in the `Atoms` and `Velocities` sections
will depend on the `atom_style` the code is told to use. In most recents
versions of LAMMPS, writing a data file with `write_data` will append a comment
next to the `Atoms` section name (here `# atomic`). This helps human readers to
know the meaning of the different number. Some formats can include more
information like a molecule tag, particles' charges, particles' spins or
orientation etc. For the velocities, some `atom_style` can require keeping
track of angular momentum, angular velocities etc. You'll find a detailed
description of each format in the `read_data section of the manual`_.

As a first takeaway, remember that `data files` contain detailed information
on a simulation system at a given time. They are more convenient for input and
output. Several simulation softwares allow you to export files as LAMMPS
`data files` and take them as input. But data format are not straightforward to
use for analyses: they are heavy and may contain useless information. This is
what the dump file format is for.

Dump file format
****************

Following the previous sections, open the `dump.lammpstrj` file that should
have appeared in your directory. This is a `dump file` containing a single
`snapshot` You should see something like this:

.. code-block:: LAMMPS

  ITEM: TIMESTEP
  0
  ITEM: NUMBER OF ATOMS
  125
  ITEM: BOX BOUNDS pp pp pp
  0.0000000000000000e+00 5.0000000000000000e+00
  0.0000000000000000e+00 5.0000000000000000e+00
  0.0000000000000000e+00 5.0000000000000000e+00
  ITEM: ATOMS id type xs ys zs
  1 1 0 0 0
  2 1 0.2 0 0
  3 1 0.4 0 0
  4 1 0.6 0 0
  5 1 0.8 0 0
  ...

The format is more simple compared to the data file. Each section is labeled
with a header directly followed by the data we wanted to dump. Here we used the
basic atom dump_style so we only have atoms' id, types and scaled coordinates
(that is coordinates divided by box length in each dimension).

You can compare the `dump file` with the `data file`, and
see that they basically contain the same information, with few
exceptions, namely the total number of types, masses and the velocities. Getting only the
scaled coordinates of the atoms is not alway ideal, but fortunately we can get
much more.

In your `in.lmp` file, replace the `write_dump` line with the following:

.. code-block:: LAMMPS

   write_dump all custom dump.lammpstrj id type x y z vx vy vz

Save the file, and run the code as previously:

.. code-block:: bash

   lmp -i in.lmp

Now the `dump.lammpstrj` file should have changed to the following:

.. code-block:: LAMMPS

  ITEM: TIMESTEP
  0
  ITEM: NUMBER OF ATOMS
  125
  ITEM: BOX BOUNDS pp pp pp
  0.0000000000000000e+00 5.0000000000000000e+00
  0.0000000000000000e+00 5.0000000000000000e+00
  0.0000000000000000e+00 5.0000000000000000e+00
  ITEM: ATOMS id type x y z vx vy vz
  1 1 0 0 0 0 0 0
  2 1 1 0 0 0 0 0
  3 1 2 0 0 0 0 0
  4 1 3 0 0 0 0 0
  5 1 4 0 0 0 0 0
  ...

The `custom` format allows
you to write every properties of each atoms to the file. There are a series of
keywords that you can use depending on the `atom_style` and values that you
can also calculate through the use of LAMMPS computes and variables. More on
that in later tutorials.

For now on we haven't done much with our atoms. Let's see how to run an actual
simulation in the :ref:`setting-up-simulations` section.

.. _read_data section of the manual: https://docs.lammps.org/read_data.html
