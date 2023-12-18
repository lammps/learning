.. _running-post-processing:

===========================
Running and post-processing
===========================

The run command
***************

The `data.lmp` file LAMMPS has written for us in the previous section should be
the configuration to use to start a new simulation. Let's make a new directory
called `NVE` and copy the file `data.lmp` there.

.. _note::

   You can chain many simulations in a single LAMMPS script and make a lot of
   complicated computations in one go. However this is prone to error. If
   anything goes wrong and makes LAMMPS crash, all unsaved data will be lost.
   Splitting simulations in several equilibration and production phases with
   intermediate file writing is generally considered good practice. For this
   tutorial, this is the chosen workflow. That being said, it is up to you to
   find your own pace.

We can make a new `in.lmp` file here to contain only the instruction related
to our simulation. Let's open a new file add the following lines:

.. code-block:: LAMMPS

   pair_style lj/cut 2.5
   read_data data.lmp

   run 10000

   write_data data.out.lmp

The `run<https://docs.lammps.org/run.html>`_ command is the one iteratively applying time integration as it goes.
Here we tell it go through 10000 timesteps. Execute the code the same way as
before by typing `lmp -i in.lmp` in your terminal. As before you should see
some text on your screen. But let's have a look to the `log.lammps` file that
is now in your directory. The text is the same as what appeared on your screen
but it is easier to go through a text file.

.. _note::

   The `log<https://docs.lammps.org/log.html>`_ command allow you to
   change the name of the log file in your script. The -l command-line option
   allows you to do the same.

In the log file, you will also find the commands and comments that were read
and executed through the script. Below the `run 10000` command, you will see
a lot of new information that were not present in the previous run. For now
lets focus on the part that starts with `Per MPI rank memory allocation...` and
`Loop time of...`. This is the main output of your run command where you will
find most information related to computed quantities such as temperature,
pressure, etc computed during your simulation. This part is controlled through
the `thermo<https://docs.lammps.org/thermo.html>`_ and `thermo_modify<https://docs.lammps.org/thermo_modify.html>`_
commands. But the default only tells us what was computed on each 10000 step
of our run, which is not very useful for us. Let's go back to our script.

Before the run, we can ask the output to be done more regularly by adding the
following:

.. code-block:: LAMMPS

   ...
   thermo 1000
   run 10000
   ...

Now if we run the script again we can see that the log contains 9 more values.
But these are always the same, so basically nothing is happening. This is
because we didn't tell the code to do anything on our atoms! For that, we
need to use `fix<https://docs.lammps.org/fix.html>`_ commands.

Integrating the equations of motion
***********************************

In LAMMPS a fix is

     ...any operation that is applied to the system during timestepping or
     minimization. Examples include updating of atom positions and velocities
     due to time integration, controlling temperature, applying constraint
     forces to atoms, enforcing boundary conditions, computing diagnostics,
     etc. (see `fix<https://docs.lammps.org/fix.html>`_)

This means that if we want atoms to update their position based on the force
they experience, we have to use one of the integrating fixes. Fix
`nve<https://docs.lammps.org/fix_nve.html>`_ integrates the positions using
the velocity Verlet algorithm. [Classics]_ NVE stands for integration with
constant number of particles (N), Volume (V) and Energy (E) but it is
important to emphasize that this fix **only integrates the equation of
motion**. The corresponding NVE ensemble (or micro-canonical ensemble) is
only produced when such integration is done on periodic system without any
source or sink of energy (external forces, fields, drag forces etc.) That being
said, let's add the following to our input script:

.. code-block:: LAMMPS

   ...
   thermo 1000
   fix 1 all nve
   run 10000
   ...

Now if we run the simulation, we can see that there is some change in the
values. Notably, the `Temp` column shows us that the temperature, which is
proportional to the kinetic energy [Classics]_ evolves, as well as the `E_pair`
column which show the non-bonded interaction. This is fine, but what can we
also simply compute on such a system?

.. note:

   One might notice that, contrary to what is stated above, the `TotEng` column
   containing the total energy of the system is not exactly constant. This is
   unfortunately due to the use of finite differences to compute new position
   from the forces and a small timestep value. This is a well known problem in
   molecular dynamics. However are, on average, very stable over long time
   period.

Modifying the thermo output
***************************

.. [Classics] Classical textbooks
