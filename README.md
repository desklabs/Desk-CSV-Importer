Desk.com-CSV-to-Case
====================

These scripts will import CSV files as specified below into a desk.com account.

<https://github.com/desklabs/Desk.com-CSV-to-Case/blob/master/CSV_Spec.md>

createTestCSVs.rb will generate dummy CSV's with data that checks out.

Requirementsgit
---------------

-   Ruby 2.3.0

-   working installation of bundler

-   git (The simplest way is to install the desktop app here:
    <https://desktop.github.com/>)

Installation
------------

There are a few requirements we should check before proceeding.  


OSX
---

Since you are using OSX, you already have Ruby installed. However, I recommend
using a system called RVM to allow you to have multiple versions of Ruby and
keep your project dependencies (gemsets) separate.

### Git

There are a couple ways to install Git.  The easiest is via the desktop app
here: <https://desktop.github.com/>

### RVM

You should read the instructions here: <https://rvm.io/>, but here are the
terminal commands needed for installation:

`gpg --keyserver hkp://keys.gnupg.net --recv-keys
409B6B1796C275462A1703113804BB82D39DC0E3`

`\curl -sSL https://get.rvm.io | bash -s stable`

### Ruby

Now with RVM installed, we need to install a fresh version of Ruby:

`rvm install 2.3.0`

 

Windows
-------

### Ruby

Windows does not come with Ruby installed. Head over to
<http://rubyinstaller.org/downloads/> and download and install Ruby 2.3.0 (or
Ruby 2.3.0 x64 if you have a 64-bit computer)

### Git

As mentioned above, the easiest, and preferred was on installing git is to
install the desktop app. This will also install a program called Git Shell. You
will use Git Shell to run this script in the future.

After the installer finishes, you should see a program called Git Shell on your
desktop.  Open that up.  You should see a command prompt.

 

Script setup
------------

Navigate to your Desktop by typing:

`cd ~\Desktop`

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

 
