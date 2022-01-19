# Automation Guidelines

This repository will grow with more information.  It's intended
for people who are looking to either improve their Automation processes
or "get ahead of the game" by starting off in a better posture.
This is not to be thought of as being "set in stone", but more of "what to tend
toward."

This document mostly will focus on "what to do" as opposed to "how to do it."
"How **I** do it" is similar but significantly more expansive, and is
documented elsewhere. 

These standards apply to all programming languages that run in a Unix
environment which you'd like to use for automation.  It's meant to be language
agnostic.

At the end of this document is a bash script that does many of these things.

In src/bin of this repository there is my_script.sh , which contains more
goodness, and example code.

This document will be written from the perspective of wanting to use cron
to schedule jobs.

# For the Purposes of this Document

When I say, things like "output to a file", I mean a storage and retrieval system.
You could also sftp files different places, us NFS, etc.

# For the Inexperienced

You MUST get good at a revision control system if you're automating things.

Automating things can seem daunting.  I recommend that you read through
this document just to get an idea of what you should be moving toward.
You don't need to memorize it.

Then:

* Create a repository that's laid out as documented in the "File system / 
Repository Layout" section of this document
* Put the script at the end of this document in the src/bin dir of the repository
* Experiment and get a good idea of what's going on.  Get comfortable.

# For the Experienced

Please submit pull requests ;)

# Program Standards

## Problems

Problems encountered and detected typically fall into two categories:

* Immediate Action
* Deferred Action

Unless it's otherwise a bad idea to do so (privacy, or another reason) problems
should be logged (to, say, syslog).

Problems requiring immediate action should, for example, write to stderr
(which will cause cron to send an email).

Problems that don't need immediate attention "aren't really problems", they're
just things you need to get around doing


## Human Interaction: Immediate Actions and Deferred Actions

TODO: This section needs a bit of work.

It's best to decouple the "reporting" aspect and the "alerting" aspect.

Write your programs in a manner that helps you "get around to 
it later", even if you plan on immediately acting on the information provided.

Prioritization is up to you, and priorities change.  If you have to change code
to make something "less important", it's more likely that you won't change it
and then you'll start ignoring things.

## Unix Standards

Good Unix "non-interactive" "automation" programs:

* Do not output anything to stderr or stdout UNLESS:
	* they've been told to (i.e. debug, verbose, etc).
	* Something went wrong.  (Use stderr for this.)
	* They've been designed to as some sort of "human interface", like **mtr**
	or **traceroute**.
* exit 0 when stuff goes OK.
* exit non-zero when stuff goes wrong.

Where do you output "reports" ?  To files.

## Add verbose and debug options to your scripts

These should default to off.  That way, when you cron it, it
works according to the cron standards listed below.

These can be enabled from, for example, environment variables or command
line arguments.

## File system / Repository Layout (How)

You need to choose and standardize where things are going to be installed,
and laid out.

### Repository Layout

Here's an example repository layout that's similar to what I use.

```
example_repo/
├── doc
│   └── index.md
├── Makefile
├── README.md
└── src
    ├── bin
    │   └── example-repo_hello.sh
    ├── etc
    ├── input
    ├── log
    └── output
```

These get checked in:

* doc - More expansive documentation about the project (if needed)
* Makefile - Does what Makefiles do.
* README.md - documentation overview
* src/bin - where your scripts go
* src/etc - non-sensitive configuration files

The following directories do not get checked in (use .gitignore)

* src/input - Where the scripts look to consume files
* src/log - Where log files go (if you're not logging to syslog; I log to syslog)
* src/output - Where things like "reports" go

src/bin/my_script.sh works inside of this.


### File system Layout

If you're not going to deploy things with packages, a basic layout could look
something like:

#### /opt
```
/opt
└── AwesomeSchool
    ├── bin
    │   ├── example-project1_hello.sh -> ../repos/example_project1/src/bin/example-project1_hello.sh
    │   ├── example-project2_hello.sh -> ../repos/example_project2/src/bin/example-project2_hello.sh
    │   └── example-project3_hello.sh -> ../repos/example_project3/src/bin/example-project3_hello.sh
    ├── output
    │   ├── example_project1 -> ../repos/example_project1/src/output/
    │   ├── example_project2 -> ../repos/example_project2/src/output/
    │   └── example_project3 -> ../repos/example_project3/src/output/
    └── repos
        ├── example_project1
        │   ├── doc
        │   │   └── index.md
        │   ├── Makefile
        │   ├── README.md
        │   └── src
        │       ├── bin
        │       │   └── example-project1_hello.sh
        │       └── output
        │           └── example-project1_hello
        │               └── 2019-05-18-07-51-30--sample.txt
        ├── example_project2
        │   ├── doc
        │   │   └── index.md
        │   ├── Makefile
        │   ├── README.md
        │   └── src
        │       ├── bin
        │       │   └── example-project2_hello.sh
        │       └── output
        │           └── example-project2_hello
        │               └── 2019-05-18-07-52-15--sample.txt
        └── example_project3
            ├── doc
            │   └── index.md
            ├── Makefile
            ├── README.md
            └── src
                ├── bin
                │   └── example-project3_hello.sh
                └── output
                    └── example-project3_hello
                        └── 2019-05-18-07-52-48--sample.txt

```

Where:
* AwesomeSchool is the name of your institution

#### Service User Home directory

```
/home
└── service-user
    └── .config
        └── AwesomeSchool
            ├── example-project1
            │   └── credentials.json
            └── example-project2
                └── some_secret.txt
```

I put credentials in the service user's home directory (with the appropriate
permissions, of course).  

#### /etc

```
/
└── etc
    └── AwesomeSchool
        ├── awesome-project2
        │   └── some_config.conf
        └── awesome-project3
            └── project3-config.json
```

Credentials can also go under /etc, with the appropriate permissions.

#### How Does This Work?

##### Repositories

* You clone / check out repositories under /opt/AwesomeSchool/repos using
a user that's DIFFERENT than the service account user
* Change the output directory to be writable by the service account user
* When you want to update, you run "git pull", or whatever.  Keep in mind,
you should have some way of logging what version of what repo is currently pulled
* Don't put credentials in the repository.  Use /etc, or ~/.config/AwesomeSchool/project-name

##### Symbolic Links

You can, for example, symbolically link /opt/AwesomeSchool/repos/example_project1/src/bin/example-project2_hello.sh to /opt/AwesomeSchool/bin/example-project2_hello.sh .  But you
should use relative links, as described above.

You can also do the same thing for the output directories as well.

Configure apache to export (password protected (if necessary), over https) directories
under /opt/AwesomeSchool/output

##### Installation

Putting this all together (if you're not using packages), installation consists of:

* Cloning / checking out the repository to /opt/AwesomeSchool/repos
* Logging which version of the repository is checked out / cloned
* Modifying the permission of the output directory
* (Optionally)
	* Symbolically linking (whichever)files under repos/example_project1/src/bin/ to /opt/AwesomeSchool/bin
	* Symbolically linking repos/example_project1/src/output to /opt/AwesomeSchool/output
	* Configuring apache appropriately

##### Updates

* Pulling whatever version of the repo you want
* Logging which revision is currently installed
## Logging

For this section, logging refers to things like:
* the progress of a program
* logging actions taken
* problems along the way
etc

There's a subtle difference between these logs and the "output" of a program,
such as a "report".

Not all programs need to log, but in general, if I'm cronning something then
I want it to log, and more so than what Cron logs by default.

Sometimes I wrap a non-logging program in a program that does log.  This is
typically what I do when something, such as a series of pipes, needs to be
cronned up.

A good default for logging is syslog.  It gets a lot of (deserved) flack
for not being easily parsed, but it gets the job done.

For example, 'logger' for bash, or Logger::Syslog for Perl.

When a program starts it should log:

* Current user running the program
* Current path to the program, and the working directory ($0 and pwd in bash)

When the program finishes:

* If the program failed, it should log that it failed 
* It should log that it's ending


## Successive Runs

If a program can not be run over and over again without negative side affects
DOCUMENT IT.

If a program can be run over and over again without negative side affects,
it's a good idea to document that.

## Concurrent runs

If a program can not be run at the same time of another run of itself, it should
be written so it detects that another instance of it is running.

Example:

* Check for a pid file under /var/run,
* If it's there
	* Write to stderr about how it's there (and log it, if applicable)
	* exit non-zero.
* If not, put a pid file under /var/run
* Remove the file when you're done


## Service User Accounts

* Do not cron things as your own user.  Use a service user account.
* You should avoid cronning things as root unless it needs it. (Principle of least
privilege, etc).  If, say you need to run nmap as a privileged user,
Try this line for sudo config: ```service_user_name ALL= NOPASSWD: /usr/bin/nmap```
* Have email from that service user account forwarded to a mail address that is a
group, even if that group only consists of one person.

This prevents things like:

* "Oh, the user that had that important processed cronned left.  His account
was disabled.  That's why it didn't run"

## /etc/cron.d/ , and Cron

Don't redirect the output of stderr and stdout in a cron entry.  If you
wrote your script to not output when stuff doesn't go wrong, then
you shouldn't need to do this.  If you wrote your script to log, then
you shouldn't need to do this.

This means that when something DOES go wrong, you should get emailed.

Don't use individual user's crontab files to cron up things.  If you're
gonna cron, use /etc/cron.d .  If it's important:

* It shouldn't run as a non-service user account
* It should require some level of restricted permissions to alter

### "Long" (as in long commands) or "complex" cron jobs

Cron jobs at most should only:
	* (Optionally) Source environment settings via a "."
	* (Optionally) run a simple if statement (i.e. Is this service running?)
	* Run one command that's optionally wrapped inside another command; 
	i.e. ```ssh user@host "ls"```

Separate scripts (anything more...):
	* multi-step processes
	* Processes that require lots of arguments

A long string, or a long path are not necessarily an issue.

If the script:
	* makes no changes to the system
	* is otherwise trivial
	* is not part of critical infrastructure
	
then the rules can be (slightly...) relaxed.

### Don't Redirect STDOUT or STDERR; But...

Ideally, Unix programs shouldn't output anything if stuff ran without issue, unless they're told to be verbose.

Some programs violate this convention.  Also, sometimes we'd like to know that a program (which violates this convention) has successfully run.

This is why it can be dangerous to redirect all output of a program in a cron job to, say, /dev/null.

As a middle ground, we can:
* copy stderr to syslog (via logger), and redirect that to stdout
* redirect stdout to syslog (via logger)

This way (although there might be the potential for a reordering of stdout and stderr via logger):
* We won't see stdout messages from cron
* We will be emailed stderr messages from cron
* We can examine syslog, which should contain both

In order to accomplish this, these commands can be put at the top of a script, or before the command in a cron job:

```
# Environment Settings
PATH="/sbin:/bin:/usr/sbin:/usr/bin"
SHELL=/bin/bash
# MAILTO=email@example.com

# This is order dependent.
0 * * * * exec 2> >(tee >(logger) ) ; exec 1> >(logger) ; /your/command/here ...
```

Here's an example test script:
```
#!/bin/bash

# This is order dependent.
exec 2> >(tee >(logger) )
exec 1> >(logger)

echo "This is a test of stdout."
>&2 echo "This is a test of stderr."
```

## Email

Scripts that send email (say, using another program) should include:

* the host name
* the path to the script
* the name of the user running the script

inside the text of the email.

## Emailing Output

Email the output of something only it's important that it gets emailed.

Otherwise (this is just one way to do it), have your programs output to a
standardized path, such as:
* /opt/institution/output/program_name/

And then have apache export /opt/institution/output over https as a password
protected directory.  That way:

* Large output won't be emailed.
* You can see in the logs who's viewing the output of a process.

You can also use *find* to remove old output after a while.

# Code Repositories

Don't fear multiple git repos.  It's better to find a way to manage
many git repos than it is to combine disparate things into one git repo.

If you're deploying code make sure you have a way to find out what repository
the code came from. 

# Documentation

Markdown is pretty cool.  README.md in the project root is a good idea.

Wikis are pretty cool but you should strive to make documentation relevant to
the code live closer to the code.  Wikis are useful to document the environment
that your programs run in.

* Document the code with "as native" of documentation you can for the code.
	* i.e. for Perl, use POD

# Deployment

That's up to you.  I use (shameless plug):

* https://github.com/theias/ias_package_shell

# Example Bash Script

Here's an example bash script that has a lot of good things going on.
This is just one way to do it.  Under /src/bin of this repository you will
find a more comprehensive script that contains more useful stuff.

* my_script.sh

```
#!/bin/bash

MY_SCRIPT_DEBUG="${MY_SCRIPT_DEBUG:-0}"
MY_SCRIPT_VERBOSE="${MY_SCRIPT_VERBOSE:-0}"

function my_script_debug
{
	if [[ "$MY_SCRIPT_DEBUG" == "1" ]]
	then
		>&2 echo "$@"
	fi
}

function my_script_verbose
{
	if [[ "$MY_SCRIPT_VERBOSE" == "1" ]]
	then
		>&2 echo "$@"
	fi
}

function write_log
{
	logger "$0[$$]: $@"
}

write_log "$0 $@ $LOGNAME $$ $( pwd ) ---STARTING---"

# Put your code here.

my_script_debug "This is a debug message."
my_script_verbose "This is a verbose message."

write_log "$0  ---ENDING---"

```

Then you can run:

```
my_script.sh
```
Which shouldn't have outputted anything.  Check syslog.

If you then run this:
```
export MY_SCRIPT_DEBUG=1
export MY_SCRIPT_VERBOSE=1
my_script.sh
```

You should see:

```
This is a debug message.
This is a verbose message.
```

The motivation for debug and verbose messages to go to stderr is that if
you're piping to something that listens on stdin, output on stderr shouldn't
interfere with it.

# For the Future

I'm open to the possibility of creating a workshop for "How __I__ do things"
if the interest is there.

# Idiosyncrasies

## Hyphens vs. Underscores

When referring to a "project", I use underscores.  When referring to an artifact
I use hyphens.


