#!/bin/sh

kdevelop-list-repos.sh | grep -Ev "kdev-xml|kdev-crossfire|kdev-sql|kdev-xtest|kdev-java|kdev-xdebug|kdev-rust|kdev-control-flow-graph|kdev-php-formatter"

# TODO: Remove kdev-rust
