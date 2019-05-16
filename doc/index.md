# Automation Standards

This repository will grow with more information.  It's intended
for people who are looking to either improve their Automation processes
or "get ahead of the game" by starting off in a better posture.

These standards apply to all programming languages that run in a Unix
environment.

At the end of this document is a bash script that does many of these things.

# Program Standards

## Unix Standards

Good Unix programs:

* Do not output anything to stderr or stdout UNLESS:
	* they've been told to (i.e. debug, verbose, etc).
	* Something went wrong.  (Use stderr for this.)
* exit 0 when stuff goes OK.
* exit non-zero when stuff goes wrong.

## Add verbose and debug options to your scripts

These should default to off.  That way, when you cron it, it
works according to the cron standards listed below.

These can be enabled from, for example, environment variables or command
line arguments.

## Logging

Not all programs need to log.  Sometimes I wrap a non-logging program
from a program that does log.  In general, if I'm cronning something
I want it to log.  Cron will log when it has run something, but not much else.

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
	* exit.
* If not, put a pid file under /var/run
* Remove the file when you're done


## Service User Accounts

* Do not cron things as your own user.  Use a service user account.
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
gonna cron, use /etc/cron.d .

## Email

Scripts that send email (say, using another program) should include:

* the hostname
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
This is just one way to do it.

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
	logger "$0[$$]: "
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
Which shouldn't have outputted anything.  Check syslog, you'll see:


```
export MY_SCRIPT_DEBUG=1
export MY_SCRIPT_VERBOSE=1
```

Which should output:

```
This is a debug message.
This is a verbose message.
```


