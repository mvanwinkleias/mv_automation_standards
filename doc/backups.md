# Backups

## Where

A good way to do backups is for each (say) appliance to
* create a user specifically for that appliance
* create a home directory for that user
	* Set the permissions appropriately!  You probably don't need users other than the appliance user and root to have rx perms!
* make a directory called "backups" or such (don't just back up to the home directory...)

and then put the relevant files under there.

When you create a home directory, you can also store things like ssh keys under that home directory (under ~/.ssh/).
When actions like *rsync* or *scp* are performed, you should:

* use the appliance user to run the processes
* use the options appropriate for the file transfer to preserve the mtime of the files (so they are easily rotated)

The reason you should want to put things in a directory under $HOME, as opposed to just in $HOME is that it makes file rotation easier.


## Culling

Backup culling should run as the service user for that backup set

## Monitoring

If using cron to monitor then backups make sure that you use a user that isn't at risk
of getting deleted.
