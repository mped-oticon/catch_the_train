# What is this?
Show next few train departures relevant to my workplace (Oticon).

We ask Rejseplanen via pyHAFAS and do a bit of filtering.

# Packaging
Nix has about 80k packages.
But PyPI has over 200k Python packages - accessible via pip and poetry.
Nix does not, rightfully so, bother packaging all these 200k packages.

Poetry is good at Python, Nix is good at everything else.

So we'll let Poetry manage all python dependencies.
And we'll let Nix package poetry.

Poetry is quite alot more rigourous than pip, so tooling exists to turn poetry into Nix!
This way, we can have our cake and eat it too:
  * Be nix-agnostic for silly people who don't (yet) use Nix: Just normal poetry
  * For those who use Nix, nix manages everything.

# Quick-start

```
nix-shell --pure https://github.com/mped-oticon/catch_the_train/archive/refs/heads/master.tar.gz --run '$out/bin/catch-the-train'
```

