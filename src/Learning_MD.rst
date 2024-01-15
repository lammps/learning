################################################################
Learning Molecular Dynamics with LAMMPS (version |version|)
################################################################

LAMMPS is a classical molecular dynamics simulation code focusing on
materials modeling.

Quoting the first paragraph of the overview section of the manual_:

  LAMMPS is a classical molecular dynamics (MD) code that models ensembles of
  particles in a liquid, solid, or gaseous state. It can model atomic,
  polymeric, biological, solid-state (metals, ceramics, oxides), granular,
  coarse-grained, or macroscopic systems using a variety of interatomic
  potentials (force fields) and boundary conditions. It can model 2d or 3d
  systems with sizes ranging from only a few particles up to billions.

In this tutorials, you will find step-by-step guides that aim at giving you
some fundamental comprehension of the code, basic input/output manipulation and
visualization of your simulation in order to give you some autonomy in the use
of the LAMMPS software. This does not replace proper teaching of statistical
mechanics and direct adivising from skilled users close to you and your work
environment but should give you some basic understanding to start your learning
of molecular simulation.

These tutorials assume you are familiar with text file manipulation, basic
command-line use and your computer environment. They also assume you already
have the last version of LAMMPS executable installed. If not, contact your IT
departement or follow the `installation guide
<https://docs.lammps.org/Install.html>`_ from the manual. If necessary, also
see `how to run LAMMPS executable dedicated section.
<https://docs.lammps.org/Run_head.html>`_ LAMMPS usage is generally easier on
UNIX like systems (Linux distributions, macOS) so most examples will assume
this type of environment. On Windows systems, you can set-up WSL to be in an
equivalent environment.

As for now the tutorial is organised in three main sections, mainly:

1. Beginner: for people who have no experience whatsoever with molecular
   simulation codes
2. Advanced: for people with some familiarity with molecular simulation that
   want to know how to do more refined things in LAMMPS.
3. Confirmed: Detailed discussions on the howto examples from the manual.

.. note:
   As this is a LAMMPS tutorial and not a molecular simulation tutorial, some
   topics of general knowledge will not be covered in details here. You will
   find more information in classical textbooks such as Allen and Tildesley
   "Computer simulation of fluids", Frenkel and Smit "Understanding molecular
   simulation" and many others statistical physics textbooks. Such topics shall
   be noted with a reference to "Classical textbooks".

****************
Table of content
****************

.. toctree::
   :maxdepth: 2
   :numbered: 2
   :caption: Table of content
   :name: tutorialtoc
   :includehidden:

   Beginner
   Advanced
   Confirmed

.. _manual: https://docs.lammps.org
