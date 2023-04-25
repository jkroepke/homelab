//go:build windows

package main

import (
	"syscall"

	"golang.org/x/sys/windows"
	"golang.org/x/sys/windows/svc/eventlog"
)

const (
	// NeLogOemCode is a generic error log entry for OEMs to use to
	// elog errors from OEM value added services.
	// See: https://github.com/microsoft/win32metadata/blob/2f3c5282ce1024a712aeccd90d3aa50bf7a49e27/generation/WinSDK/RecompiledIdlHeaders/um/LMErrlog.h#L824-L845
	neLogOemCode = uint32(3299)
)

func main() {
	msg := "This is a Message"

	logger, err := eventlog.Open("demo")
	if err != nil {
		panic(err)
	}

	for i := 1; i <= 10; i++ {
		err = logger.Info(uint32(i), msg)
		if err != nil {
			panic(err)
		}
	}

	err = logger.Info(neLogOemCode, msg)
	if err != nil {
		panic(err)
	}

	logMsg, err := syscall.UTF16PtrFromString(msg)
	if err != nil {
		panic(err)
	}

	ss := []*uint16{logMsg, nil, nil, nil, nil, nil, nil, nil, nil}

	err = windows.ReportEvent(logger.Handle, windows.EVENTLOG_INFORMATION_TYPE, 0, neLogOemCode, 0, 9, 0, &ss[0], nil)
	if err != nil {
		panic(err)
	}
}
