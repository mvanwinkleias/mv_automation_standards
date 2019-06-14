# Automation FAQs

Usually when somebody asks a question, "How do I X?", there are Do's and Don'ts.

If I provide a "Don't", I'll try to provide a "How", which will just be an example.

## Getting Started

### Revision Control Systems

This is the only part in this document where I will speak prophetically.

For home-grown programs, it really begins when you:
* Put code into a revision control system, such as git, or subversion.
* Come to an agreement on how repositories should be organized
* Come to an agreement on how programs should be deployed

Yes, automation existed before those revision control systems existed, but managing
automation environments without revision control is the pathway to misery.

If you want to automate things: learn how to use a revision control system.

## Credentials

### Do's and Don'ts

#### Don't

* Do not put credentials in the same repository next to code.

#### Do

* Ensure that sensitive files have the appropriate permissions.
* Standardize on how to organize sensitive files.

### Example Hows

#### Permissions

```
chown service_user credentials.json
chmod 600 credentials.json
```

#### JSON

I like to store my credentials in JSON files.  Makes it easy to expand.

#### JSON + Lastpass

The Lastpass command line client offers the ability to export an entry as json.
* Export the entry you want to use in json format to ~/.config/AwesomeSchool/project-name/credentials.json
* Write your programs to accept credentials in the form of json files.

#### A Simple File

You can also do things like put the user name on one line, and the password on the second line:

```
some_cool_user
some_unguessable_password
```

## Logging

Basic logging functionality should include when a program started, finished, and
if it encountered any problems.

More in-depth logging can be considered a report, and you might want to handle that
differently than basic logging.

### Do's and Don'ts

#### Don't

* Log sensitive information to, say, syslog.
You should decide where to "log" sensitive information.
Local files are a good option (with the correct permissions, of course).

#### Do

* Log when a program starts and ends.
* Log the arguments the program was run with (unless they're sensitive; but why are you
running programs with sensitive arguments?)
* Have different options (verbose, debug) for logging when the log messages get unwieldy.
* Recognize the difference between "logs" and "reports".  If a program logs many actions,
you might want to output that to a separate file, and then log something like:
	* ```Actions performed logged in: /opt/AwesomeSchool/output/project-name/script_name/2019-06-12-actions.txt```
	
## Emailing

### Do's and Don'ts

#### Don't

* Don't email output, unless necessary.  You should prefer to email the location
of the files generated.  This helps prevent emailing sensitive information.

#### Do

* Include the host name, user, and path to the script that generated the email.
If you have a rogue program sending out email, tracking it down can be VERY annoying.
This helps.
