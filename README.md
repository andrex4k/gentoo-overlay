# gentoo-overlay
### Installation

```bash
tux ~ # emerge -a dev-vcs/git app-eselect/eselect-repository
```
### Add overlay

```bash
tux ~ # eselect repository add andrex git https://github.com/andrex4k/gentoo-overlay.git && emerge --sync
```

### Legacy compatibility eclasses

Some ebuilds here predate the removal of `eutils.eclass` and `user.eclass`
from the Gentoo tree.  `eclass/eutils.eclass` and `eclass/user.eclass` are
minimal compatibility shims that keep them working (`epatch`,
`epatch_user`, `enewuser`, `enewgroup`).  New ebuilds should use
`PATCHES`/`eapply` and GLEP 81 `acct-user`/`acct-group` packages instead.
