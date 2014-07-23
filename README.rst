===================
Hooray for Captain!
===================

.. image:: https://api.travis-ci.org/mozilla/captain.png
   :target: https://travis-ci.org/mozilla/captain

.. image:: https://coveralls.io/repos/mozilla/captain/badge.png?branch=master
   :target: https://coveralls.io/r/mozilla/captain?branch=master

Captain is the web frontend for the `Captain Shove`_ system. It sends commands to the Shove_
process, which executes the commands on a remote server.


Project details
===============

:Code:          https://github.com/mozilla/captain
:Documentation: http://captain.readthedocs.org/
:Issue tracker: https://github.com/mozilla/captain/issues
:IRC:           ``#capshove`` on irc.mozilla.org
:License:       Mozilla Public License v2


.. _Captain Shove: https://wiki.mozilla.org/Websites/Captain_Shove
.. _Shove: https://github.com/mozilla/shove


Building a Test Environment with Puppet and Vagrant
---------------------------------------------------
A ``Vagrantfile`` is provided that will spin up multiple machines in a realistic
development environment. The machines spun up by vagrant rely on puppet code
found in the ``puppet`` directory.

.. note::
    If you need to make persistent changes in a settings file in either shove or
    captain you *must* make the changes in captainshove's puppet module
    (`captainshove-puppet <https://github.com/uberj/captainshove-puppet.git>`).
    Once your chnages are in the upstream captainshove-puppet module asking
    vagrant to reprovision (i.e. ``vagrant provision``) should pull in any
    changes.

Nodes are classified in ``puppet/manifests/vagrant.pp``. If you decide to add
more machines to your test environment make sure to add them to puppet!

To bring up the development environment do::

    vagrant up --provision

On first run, puppet will install shove into a ``shove/`` directory in the
captain project root. You can make changes to both captain and shove and have
your changes installed by running ``vagrant provision``.

The hosts in vagrant need to use ``"private_network"`` ("host only addresses")
and have been assigned arbitrarily chosen private addresses. If you feel the
need to change the addresses make sure to update the addresses in
``puppet/manifests/vagrant.pp``.

Using The Vagrant Test Environment
----------------------------------
After successfully installing your test environment you will have a working
captain/shove environment. To access captain, point your browser at
``127.0.0.1:800``.

Both the captain development server and shove daemon are running in screen
sessions in their respective virtual machines. On login to either captain or
shove, you will be dropped into an active screen sessions. If your
screen sessions ever die run puppet again (i.e. ``vagrant provision``) to
automatically restart them.  Alternatively, you can, `as the vagrant user`, run
either::

    screen -S captain python manage.py runserver 0.0.0.0:8000

Or::

    screen -S shove shove
