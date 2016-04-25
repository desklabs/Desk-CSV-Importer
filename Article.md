To import a CSV we are going to write a Ruby script. There are a few
requirements we should check before proceeding. The instructions differ
depending on which OS you are using.

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
