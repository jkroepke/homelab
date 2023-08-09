module github.com/jkroepke/homelab/go/windows-eventlog

go 1.20

require golang.org/x/sys v0.7.0

replace (
	golang.org/x/sys v0.7.0 => ./sys
)
