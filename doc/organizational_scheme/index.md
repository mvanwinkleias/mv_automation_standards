# The Tools I Use and How I use them

In generall, I tie everything together:

* Revision control commit messages contain the ticket numbers for the issue you're working on
* The wiki contain
	* links to the repositories for projects
	* links to tickets
	* links to external documentation (etc)
	* Project Documentation
* Project Repositories
	* mention the wiki for "environment specific" documentation
	* contain project specific documentation

## Workflows

### "Semi-Critical" Maintenance

* Email ticket queue with subject like "Rebooting F-200 AP"
* Do work
* Document the work in the ticket, include circumstances, etc
* Resolve ticket

### Project Work

Sometimes when I'm working on a project, I'll need to create a ticket with another company.  Let's say I need to configure network cards on a new machine, but I'm having problems.

I'll:

* Create a ticket with a description
* Create a ticket in the other company's queue, and mention our internal ticket number
* Document the company's ticket number in my ticket

## Trello (Post-it Board)

Trello tells me what to work on.

My trello cards have links to tickets, and to documentation systems.

My manager can tell me what to work on via Trello (and the ticketing system).

## Ticketing System

Start a ticket if any of the following apply:

* You need to quickly and uniquely identify something (I.E. get a ticket number)
* People will be alerted somehow by your work
* People will want to know if something is being worked on
* You want to document it

... If it's work, you probably should have a ticket for it.

### Periodically Groom Ticketing System

You're gonna wanna do this.

* Get people to close out what they can
* Prioritize the ones that aren't closed
* Create trello tickets for them if they're important

### Break Up the Queues

Make sure you have a way of at least classifying tickets.  Some tickets were just a log that something happened.  Some cover continuing issues.  Some might just be a TODO.

I, personally, am not against having a large number of "Open" tickets.

* I log the work in the tickets.
* I put a link to the documentation in the ticket.
* I put a section, "Associated Tickets" in my documentation, and link the tickets there.

* General queue
* Group specific queues
	* maintenance
	* customer
	* etc

## Filesystem Layout

How you organize your stuff is up to you.  I like to know what I need to keep / save, what needs to be backed up, etc.



```
root/
├── home
│   └── bob
│       ├── Documents
│       │   ├── 2018-09-21-firewall_project
│       │   │   ├── administrative_guide.pdf
│       │   │   └── installation_guide.pdf
│       │   └── Personal
│       │       ├── 2018-04-02-performance_review.pdf
│       │       └── dental_paperwork.doc
│       ├── junk
│       │   ├── bash_problems
│       │   └── script_test.sh
│       ├── Pictures
│       │   └── Personal
│       ├── rt_tickets
│       │   ├── 2019-08-01-ticketing_system_unvailable
│       │   │   └── config_change.txt
│       │   ├── 28911-collocation_switch_upgrade
│       │   │   ├── big_os_image.img
│       │   │   └── installation_instructions.txt
│       │   ├── 29090-printer_issues
│       │   ├── 29110-vpn_issues
│       │   │   └── license.txt
│       │   ├── 29281-power_issues
│       │   │   └── ups_manual.pdf
│       │   └── 90192-wireless_outage
│       │       └── eduraom_cert.crt
│       ├── src_local
│       │   ├── git
│       │   │   ├── github_bobsmith
│       │   │   └── gitlab_bobsmith
│       │   └── svn
│       │       └── source-repo.example.com
│       └── src_nfs
│           └── git
│               └── github_bobsmith
│                   ├── another-repo
│                   └── some_repo_1
└── mnt
    └── nfs
        └── group_nfs
            └── rt_tickets
                └── 28959-dos_incident
                    └── 2018-04-29-13-00-00.pcap

```

### rt_tickets/ examples

In this scheme, everything that's in rt_tickets should either be in the ticketing system, or obtainable via documented means.  

#### 28911-collocation_switch_upgrade

The __28911-collocation_switch_upgrade__ directory might contain installation instructions, and an image file for the upgrade.  The ticket should document where to obtain both, and maybe the installation instructions are attached to the ticket (if they're small).

#### 2019-08-01-ticketing_system_unvailable

This is how I name things when the ticketing system is unavailable, or it doesn't warrant creating a ticket.  __YYYY-MM-DD-description__

## Documentation

### Environment Specific

This goes in a wiki.  It looks something like this:

```
# Some VPN Service

## License Information

To determine what license is installed:

* vpn_service --license

To install new license file:

* vpn_service --install-license license.txt

## Associated Tickets:
* rt.example.com/Ticket/Display.html?id=29110 - VPN Issues.  How to install license.  Tricky

```

In the ticket, I'll put a link to the page for "Some VPN Service".
