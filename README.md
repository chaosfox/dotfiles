
# my dotfiles

These are common config files I maintain in git to make it easy
to modify & distribute across multiple computers.

## Install

```terminal
git clone this.repo ~/dotfiles
cd dotfiles
git submodule update --init
perl bootstrap.pl [--exec]
```

The bootstrap check each link target to see if making the link is possible, 
with the --exec flag it actually makes the symlinks.


