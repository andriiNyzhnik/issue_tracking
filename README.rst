Support Issue Tracking System
=============================

A simple system for tracking incoming enquiries from customers with an easy to use interface for support staff to communicate with clients.

Setup
-----

#. Install Ruby dependencies:

    ``bundle install``

#. Copy configuration files:

    ``cp config/database.dev.yml config/database.yml``

#. Create db:

    ``rake db:create``

#. Import data dump:

    ``mysql -u user_name -p issue_tracking_development < config/db.sql``

#. Run migrations:

    ``rake db:migrate``

#. Start dev server:

    ``rails s``

Sign in
-------
To sign in as stuff use ``stuff@example.com`` or ``stuff2@example.com`` with password ``password``
