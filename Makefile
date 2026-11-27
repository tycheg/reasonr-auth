# The module is checked with the released framework tools: reasonr (the
# compiler) and reasonrd (the standard engine) from PATH; make tools installs
# them into $(go env GOPATH)/bin.
REASONR ?= v0.1.0

.PHONY: check tools

check:
	reasonr fmt --check src
	reasonr check
	reasonrd test src

tools:
	go install github.com/tycheg/reasonr-compiler/cmd/reasonr@$(REASONR)
	go install github.com/tycheg/reasonr-dist/cmd/reasonrd@$(REASONR)
