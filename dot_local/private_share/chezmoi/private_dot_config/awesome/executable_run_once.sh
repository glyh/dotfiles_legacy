#!/usr/bin/env bash
pgrep $1 > /dev/null || ($@ >/dev/null &)
