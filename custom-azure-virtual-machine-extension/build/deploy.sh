#!/usr/bin/env bash

set -e

cd src/handler/linux/
rm -f linux.zip
zip -r linux.zip ./*
cd -

cd src/handler/windows/
rm -f linux.zip
zip -r windows.zip ./*
cd -
