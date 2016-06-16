Desk.com-CSV-to-Case
====================

To import a CSV we are going to write a Ruby script to import CSV files as
specified below into desk.com.

<https://github.com/desklabs/Desk.com-CSV-to-Case/blob/master/CSV_Spec.md>

createTestCSVs.rb will generate dummy CSV's with data that checks out.

Requirements
------------

-   \*nix/OSX based computer (this could change when I nail down Windows
    instructions)

-   Ruby 2.3.0

-   working installation of bundler

-   git (The simplest way is to install the desktop app here:
    <https://desktop.github.com/>)

Installation
------------

There are a few requirements we should check before proceeding. The instructions
differ depending on which OS you are using.

OSX
---

If you are using OSX, you already have Ruby installed. However, I recommend
using a system called RVM to allow you to have multiple versions of Ruby.

### RVM

You should read the instructions here: <https://rvm.io/>, but here are the
terminal commands needed for installation:

`gpg --keyserver hkp://keys.gnupg.net --recv-keys
409B6B1796C275462A1703113804BB82D39DC0E3`

`\curl -sSL https://get.rvm.io | bash -s stable`

### Ruby

Now with RVM installed, we need to install a fresh version of Ruby:

`rvm install 2.3.0`

### Script setup

Now, clone this repository:

`git clone https://github.com/desklabs/Desk.com-CSV-to-Case.git`

Then cd into the directory:

`cd Desk.com-CSV-to-Case`

Since we have RVM installed, the files .ruby-version and .ruby-gemset will team
RVM to always switch to the proper version and gemset when we enter the
directory. A new gemset will be created for us the first time we enter the
directory.

Now we need to install bundler, a package management system for Ruby:

`gem install bundler`

and use bundler to install the rest of the gems we need from our Gemfile:

`bundle install`

The last step in configuration is to copy the .env.example file to .env and add
our credentials to the .env file.

`cp .env.example .env`

`open .env` (this should open a text editor. Edit and save)

 

Usage
-----

Place your CSV files in the CSV\_Files folder. They should be named:

-   customers.csv

-   companies.csv

 

`ruby company_and_customer_import.rb`

 
