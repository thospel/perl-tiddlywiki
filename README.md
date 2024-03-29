# NAME

tiddly\_update - Explode and implode a classic TiddlyWiki

# SYNOPSIS

```
tiddly_update [--version] [--unsafe] [-U] [-h] [--help]
tiddly_update [--no-git] [--verbose] [--no-strip] <dir>
tiddly_update [--no-git] [--verbose] [--no-strip] [--no-check] [--no-sync] [-m <message>] [-e] [<dir>] [<file>]
```

# DESCRIPTION

If given a directory it will build a wiki file from that and print that to
`STDOUT`. You can use that to manually generate an initial wiki file from the
git repository.

If given a file **tiddly\_update** will assume this is a tiddly wiki classic file,
split it up in parts into directory given by the optional `dir` argument or into subdirectory `exploded` found relative to the given file (**not** relative to
the current directory) and commit that to git. If there is a git remote it will
then pull from the remote followed by a push to the remote.
Then the wiki file is rebuilt.
Notice that the given directory (and subdirectories) will be created if needed
but no git repository is automatically created.

If neither file or directory is given it behaves as if you gave `index.html`
as file argument

The current git revision is stored inside the new wiki file
(in tiddler `Wiki State`). The program will also do nothing if the revision
inside the file is different from the current revision.

You can fix this by manually changing that tiddler, save the wiki and running the **tiddly\_update** on the saved file. This will update git to reflect the wiki file.

Or instead you can run **tiddly\_update** on the base directory and redirect the
output to the wiki file and reload the file in your browser. This will update
the wiki file to reflect git.

The revision check also means you should usually not do git actions that change
the revision number (like `commit` and `pull`) outside this program. The
program will commit anything that is in the git index, so you are free to do
changes in the working directory and update the git index after which you can
run this progrtam to do the git commit (possibly using the [edit](#edit) and/or
[message](#message) options).

# OPTIONS

- -v, --verbose

    Show more about the steps taken

- --git

    Use git (the default).

    Giving the corresponding `no` option does not mean that
    the git program won't be called, it just means that the git state will not be
    changed (no add, remove, commit, push or pull) and that any git errors
    (including git itself not being found or able to run) will be ignored. Notice
    that it may delete files from the filesystem even though these files are in git.

- --check

    Before splitting up the wiki file make sure that when reproducing the the wiki
    file from the parts this gives a byte for byte identical result. Otherwise
    change nothing exit with an error message.

    This check is the default. Turning it of with the corresponding `no` option
    makes the program progress anyways and will change the wiki file. This may allow
    for some implicit repairs, but it's probably safest to manually backup the wiki
    file first and carefully check the canges.

- --strip

    If true (the default), strip trailing spaces from all lines, not just from the
    tiddlers but also from the internal wiki template.

- --message, -m &lt;message>

    Use `message` as git commit message instead of the autogenerated one

- --edit, -e

    Allows you to edit the commit message (if a commit is done)

- --amend

    Amend the current commit. Take care when using this dangerous option.

    If you plan to use this best make sure that the previous commit did not do a
    push (see the [--no-sync](#sync) option) or use [--no-sync](#sync) with the
    current invocation and do a manual `git push -f` at some point in the future
    if you are sure you won't destroy unimported updates on the remote or confuse
    other users of the remote.

- --sync

    If true (the default) pull and push the repository (if a remote has been set).
    This option exists mostly so you can do `--no-sync` to avoid this.

- -h, --help

    Show this help.

- -U, --unsafe

    Allow even root to run the perldoc.
    Remember, the reason this is off by default is because it **IS** unsafe.

- --version

    Print version info.

# EXAMPLE

A typical use would be:

```perl
# Normal use
tiddly_update index.html

# Generate a new wiki from the current expansion
tiddly_update exploded > index.html
```

As mentioned the program will not set up git for you. So if you have a wiki but
no git yet:

```
# Go to the directory with the wiki, assumed to be called index.html
git init

# I like to have an empty commit at the root:
# git commit --allow-empty -m 'Initial empty commit'

# Possibly do tiddly_update on an empty tiddlywiki:
# tiddly_update exploded path_to_empty.html

# Commit your wiki:
tiddly_update index.html

# Possibly set up a remote, do an initial git push
```

If you have an exploded wiki in git but no wiki yet:

```
git clone repository
cd directory
tiddly_update exploded > index.html
```

# BUGS

None known

# SEE ALSO

[git(1)](http://man.he.net/man1/git),

# AUTHOR

Ton Hospel, &lt;tiddly\_update@ton.iguana.be>

# COPYRIGHT AND LICENSE

Copyright (C) 2019 by Ton Hospel

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.
