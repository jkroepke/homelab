package main

import (
	"errors"
	stdlog "log"

	"github.com/go-kit/log"
	"github.com/go-kit/log/level"
	"github.com/prometheus/common/promlog"
)

func main() {
	promlogConfig := promlog.Config{
		Level: func() *promlog.AllowedLevel {
			level := promlog.AllowedLevel{}
			level.Set("debug")
			return &level
		}(),
		Format: func() *promlog.AllowedFormat {
			format := promlog.AllowedFormat{}
			format.Set("logfmt")
			return &format
		}(),
	}

	logger := promlog.New(&promlogConfig)
	stdlogger := stdlog.New(log.NewStdlibAdapter(log.With(level.Error(logger))), "", stdlog.Lshortfile)

	err := errors.New("write tcp 127.0.0.1:9182->127.0.0.1:60125: wsasend: Eine bestehende Verbindung wurde softwaregesteuert\r\ndurch den Hostcomputer abgebrochen.")
	stdlogger.Println("error encoding and sending metric family:", err)
	stdlog.Printf("error encoding and sending metric family: %v", err)
}
