# adjust

**BlossomOS system command runner** – A pretty frontend for [`just`](https://github.com/casey/just) that reads `/etc/Justfile` and displays grouped system commands.

## Overview

`adjust` is a command-line utility designed for BlossomOS that provides a user-friendly interface for managing and executing system commands defined in a Justfile. It parses `/etc/Justfile`, organizes commands into logical groups, and presents them in a clean, colorized table format.

## Features

- 📋 **Grouped Command Display** – Organizes commands by categories defined in the Justfile
- 🎨 **Colorized Output** – Easy-to-read table with syntax highlighting
- 🚀 **Command Execution** – Pass commands directly to `just` for execution
- 📦 **RPM Packaging** – Ready for distribution via RPM packages

## Requirements

- Python 3.6+
- [just](https://github.com/casey/just) – Command runner

## Installation

### From RPM Package

```bash
rpm-ostree install ./adjust-1.0.0-1.*.noarch.rpm
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
rpmbuild/RPMS/noarch/adjust-1.0.0-1.*.noarch.rpm
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

system
--------
Command                        Params               Description
update                                              Update system packages
clean                                               Clean package cache
restart-network                                     Restart network services

misc
----
Command                        Params               Description
help                                                Show help message
```

### Execute Commands

Pass any arguments to `adjust` and they will be forwarded to `just`:

```bash
adjust update
adjust restart-network
```

## Justfile Format

`adjust` parses `/etc/Justfile` and recognizes the following patterns:

### Group Definitions

Commands are organized into groups using the `[group("name")]` attribute:

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

The default Justfile path is `/etc/Justfile`. To use a different Justfile, modify the `JUSTFILE` constant in the `adjust` script:

```python
JUSTFILE = "/path/to/your/Justfile"
```

## License

MIT License – See the project repository for details.

## Contributing

Contributions are welcome! Please submit issues and pull requests to the [BlossomOS repository](https://git.blossomos.org/Blossom/adjust).

## Author

Leonie Ain <me@koyu.space>
