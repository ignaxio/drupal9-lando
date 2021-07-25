# Table of contents

* Description
* Scripts
  * phpcs.sh


# Description

This folder contains scripts that help perform development related tasks or
tasks related to project deployment, etc.


# Scripts

## phpcs.sh

Executes PHP Code Sniffer to check Drupal Coding Standards against code included
in custom modules, themes or profiles.

It is required to have installed the drupal/coder module with composer. If not
already included with the project, just install as follows:

```
  composer require drupal/coder
```

Once coder is installed, an additional step is required to setup the local
development environment of Code Sniffer to find the Drupal related rules.

To install Drupal related rules, run:

```
$ phpcs.sh install-rules

vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
Using config file: /.../vendor/squizlabs/php_codesniffer/CodeSniffer.conf
Config value "installed_paths" added successfully
```

To check if the Drupal rules are installed, run:

```
$ phpcs.sh check-rules

vendor/bin/phpcs -i
The installed coding standards are PSR2, PSR12, PSR1, PEAR, Zend, MySource, Squiz, DrupalPractice and Drupal
```

Now, running the script without arguments, it will print the syntax and usage
information:

```
$ phpcs.sh

Usage: phpcs.sh [option]
where [option] may be:
   check-rules     Checks installed rules.
   install-rules   Installs Drupal rules.
   check-modules   Checks coding standards of all custom modules.
   check-themes    Checks coding standards of all custom themes.
   check-profiles  Checks coding standards of all custom profiles.
   check-local     Checks coding standards of all custom modules and themes.
   check-all       Checks coding standards of all custom modules, themes and profiles.
```
