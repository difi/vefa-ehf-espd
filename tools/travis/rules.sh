#!/bin/sh

FOLDER=$(dirname $(readlink -f "$0"))/../..

# Generate CriteriaTaxonomy rules for Schematron

docker run --rm -i \
-v $FOLDER:/src \
-v $FOLDER/target/generated:/target \
klakegg/saxon \
-s:codelist/CriteriaTaxonomy.xml \
-xsl:tools/xslt/CriteriaTaxonomy-schematron.xslt \
-o:/target/CriteriaTaxonomy.sch \
pattern_only=true

docker run --rm -i \
-v $FOLDER:/src \
-v $FOLDER/target/generated:/target \
klakegg/saxon \
-s:codelist/CriteriaTaxonomy.xml \
-xsl:tools/xslt/CriteriaTaxonomy-snippet.xslt \
-o:/target/CriteriaTaxonomy-snippet.xml

docker run --rm -i \
-v $FOLDER:/src \
-v $FOLDER/target/generated:/target \
klakegg/saxon \
-s:target/generated/CriteriaTaxonomy.sch \
-xsl:tools/xslt/CriteriaTaxonomy-structure.xslt \
-o:/target/CriteriaTaxonomy.xml

# Run vefa-structure

docker run --rm -i \
-v $FOLDER:/src \
-v $FOLDER/target:/target \
difi/vefa-structure:0.5

# Validator build

docker run --rm -i \
-v $FOLDER:/src \
difi/vefa-validator \
build -x -t /src -t -target target/validator -n no.difi.ehf.espd
