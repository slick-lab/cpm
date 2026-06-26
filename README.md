# cpm

Crystal Package Manager — a tiny wrapper around `shards` that saves you from hunting URLs.

## Why I Built This

I got tired of this workflow:

1. Want to add `kemal` to my project
2. Open browser
3. Search "kemal crystal shard"
4. Click GitHub
5. Copy the URL
6. Paste into `shard.yml`
7. Run `shards install`

That's 7 steps for something that should be 1.

`cpm` fixes this:

```bash
cpm add kemal   # Done.
```

No browser. No copy-paste. No remembering URLs.

`shards` is great at installing dependencies. But it doesn't help you *find* them. `cpm` fills that gap and gets out of the way.

---

## Install

```bash
curl -fsSl https://raw.githubusercontent.com/slick-lab/cpm/main/install.sh | sudo bash
```

---

## Usage

```bash
# Initialize a project
cpm init
cpm init --cache    # also creates ~/.cpm/cache.txt

# Search for packages
cpm search kemal
cpm search kemal --auto   # pick top result automatically

# Add a dependency
cpm add kemal

# Remove a dependency
cpm remove kemal

# Then use shards as normal
shards install
shards prune
shards update
```

---

## How it works

`cpm` doesn't replace `shards`. It just makes the `shard.yml` part easier:

- `cpm search` queries GitHub for Crystal shards
- `cpm add` checks your cache, writes to `shard.yml`
- `shards` handles the actual downloading and version resolution

We keep a simple `~/.cpm/cache.txt`:

```
kemal	https://github.com/kemalcr/kemal
pg	https://github.com/will/crystal-pg
```

No JSON. No metadata. Just names and URLs.

---

## Why not just use shards?

`shards` is perfect for what it does: resolving versions and installing dependencies.

But `shards` assumes you already know:
- The exact package name
- The GitHub URL
- Whether it's maintained

`cpm` helps with discovery. Then `shards` takes over.

---

## License

MIT
