#!/bin/bash
set -e

PACKAGE_NAME=adjust
VERSION=0.1.0
RELEASE=1
BUILDROOT=$(pwd)/rpmbuild
SPECS_DIR=$BUILDROOT/SPECS
SOURCES_DIR=$BUILDROOT/SOURCES

rm -rf $BUILDROOT
mkdir -p $SPECS_DIR $SOURCES_DIR

# Create source tarball
tar -czf $SOURCES_DIR/$PACKAGE_NAME-$VERSION.tar.gz \
    --transform "s|^|$PACKAGE_NAME-$VERSION/|" \
    adjust

SPECFILE=$SPECS_DIR/$PACKAGE_NAME.spec

cat > $SPECFILE <<EOF
Name:           $PACKAGE_NAME
Version:        $VERSION
Release:        $RELEASE%{?dist}
Summary:        BlossomOS system command runner, a frontend for just with /etc/Justfile
License:        MIT
BuildArch:      noarch
URL:            https://codeberg.org/BlossomOS/adjust

Source0:        $PACKAGE_NAME-$VERSION.tar.gz

Requires:       python3
Requires:       just

BuildRequires:  tar

%description
BlossomOS system command runner. A pretty frontend for just that reads
/etc/Justfile and displays grouped system commands.

%prep
%setup -q

%build
# nothing to build

%install
install -Dm 755 adjust %{buildroot}/usr/bin/adjust

%files
/usr/bin/adjust

%changelog
* $(LANG=C date +"%a %b %d %Y") Leonie Ain <me@koyu.space> - $VERSION-$RELEASE
- Initial release
EOF

rpmbuild -bb $SPECFILE \
    --define "_topdir $BUILDROOT" \
    --define "_sourcedir $SOURCES_DIR"

echo ""
echo "Build complete! RPM package is available at:"
echo "$BUILDROOT/RPMS/noarch/$PACKAGE_NAME-$VERSION-$RELEASE.*.noarch.rpm"
