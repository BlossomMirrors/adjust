# adjust

**BlossomOS system command runner** – A pretty frontend for [`just`](https://github.com/casey/just) that assembles `*.just` files from `/usr/share/blossomos` and displays grouped system commands.

## Overview

`adjust` is a command-line utility designed for BlossomOS that provides a user-friendly interface for managing and executing system commands defined in just recipes. It collects all `*.just` files under `/usr/share/blossomos`, organizes commands into namespaces (one per file), and presents them in a clean, colorized table format. Commands are invoked with their namespace, e.g. `adjust pkglayer list`.

## Features

- 📋 **Namespaced Commands** – Each `*.just` file becomes its own namespace
- 🎨 **Colorized Output** – Easy-to-read table with syntax highlighting
- 🚀 **Command Execution** – Validated and passed to `just` for execution
- 💡 **Helpful Errors** – Suggests the right namespace when a command is typed without one
- 📦 **RPM Packaging** – Ready for distribution via RPM packages

## Requirements

- Python 3.6+
- [just](https://github.com/casey/just) – Command runner

## Installation

### From RPM Package

```bash
rpm-ostree install ./adjust-0.2.0-1.*.noarch.rpm
```

### From Source

```bash
# Clone or download the repository
git clone https://git.blossomos.org/Blossom/adjust.git
cd adjust

# Make the script executable
chmod +x adjust

# Optionally install to /usr/local/bin
sudo cp adjust /usr/local/bin/
```

### Build RPM Package

```bash
./build.sh
```

The RPM package will be available at:
```
rpmbuild/RPMS/noarch/adjust-0.2.0-1.*.noarch.rpm
```

## Usage

### List Available Commands

Run `adjust` without arguments to display all available commands:

```bash
adjust
```

Example output:
```
adjust system commands
usage: adjust <namespace> <command> [args]

pkglayer
--------
Command                      Params               Description
remove                       pkgman               remove a pkglayer container, no prompt (for scripts)
list                                              list active pkglayer containers
```

Run `adjust <namespace>` to list only that namespace's commands:

```bash
adjust pkglayer
```

### Execute Commands

Commands are always invoked with their namespace. The remaining arguments are forwarded to `just`:

```bash
adjust pkglayer list
adjust pkglayer remove yay
```

Typing a command without its namespace prints a hint instead of running it:

```
$ adjust list
unknown command: list
did you mean: adjust pkglayer list
```

## Justfile Format

`adjust` assembles every `*.just` file under `/usr/share/blossomos` into a single Justfile and recognizes the following patterns:

### Namespaces

The file name defines the namespace: `/usr/share/blossomos/pkglayer/pkglayer.just` provides the `pkglayer` namespace. A `scripts/` directory next to a `.just` file is symlinked into `/tmp/scripts` so recipes can call helper scripts.

### Group Definitions

In the overview table, commands are grouped by their namespace by default. The `[group("name")]` attribute overrides the display group:

```just
[group("system")]
update:
    @sudo dnf update -y

[group("network")]
restart-network:
    @sudo systemctl restart NetworkManager
```

### Command Comments

Line comments above a recipe become the command description:

```just
# Update all system packages
update:
    @sudo dnf update -y
```

### Private Commands

Commands starting with an underscore (`_`) are marked as private (displayed dimmed):

```just
_internal-task:
    @echo "This is internal"
```

## Project Structure

```
adjust/
├── adjust          # Main Python script
├── build.sh        # RPM build script
├── README.md       # This file
├── .gitignore      # Git ignore rules
└── rpmbuild/       # RPM build directory (generated)
    ├── BUILD/
    ├── RPMS/
    ├── SOURCES/
    ├── SPECS/
    └── SRPMS/
```

## Configuration

Recipes are read from `/usr/share/blossomos` and assembled into `/tmp/adjust`. To change either path, modify the constants in the `adjust` script:

```python
JUST_DIR = "/usr/share/blossomos"
JUSTFILE = "/tmp/adjust"
```

## License

MIT License – See the project repository for details.

## Contributing

Contributions are welcome! Please submit issues and pull requests to the [BlossomOS repository](https://git.blossomos.org/Blossom/adjust).

## Author

Leonie Ain <me@koyu.space>
