# Automation FAQs

Usually when somebody asks a question, "How do I X?", there are Do's and Don'ts.

If I provide a "Don't", I'll try to provide a "How", which will just be an example.

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

### Do's and Don'ts

#### Don't

* Log sensitive information.  You should decide where to "log" sensitive information.  Local files
are a good option (with the correct permissions, of course).

#### Do

* Do log when a program starts and ends.
* Have different options (verbose, debug) for logging when the log messages get unwieldly.
* Recognize the difference between "logs" and "reports".  If a program logs many actions,
you might want to output that to a separate file, and then log something like:
	* ```Actions performed logged in: /opt/AwesomeSchool/output/project-name/script_name/2019-06-12-actions.txt```
