Desk.com-CSV-to-Case
====================

To import a CSV we are going to write a Ruby script to import CSV files as
specified below into desk.com.

http://desk-customers.s3.amazonaws.com/wow/migration\_services/csv\_specification.html

createTestCSVs.rb will generate dummy CSV's with data that checks out.

Requirements
------------

-   \*nix/OSX based computer (this could change if I nail down Windows
    instructions below)

-   Ruby 2.3.0

-   working installation of bundler

Installation
------------

There are a few requirements we should check before proceeding. The instructions
differ depending on which OS you are using.

OSX
---

If you are using OSX, you already have Ruby installed.  However, I recommend
using a system called RVM to allow you to have multiple versions of Ruby.

### RVM

You should read the instructions here: <https://rvm.io/>, but here are the
terminal commands needed for installation:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\curl -sSL https://get.rvm.io | bash -s stable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
