RUSTIC = target/release/rustic
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

.PHONY: all test

all:
	cargo build --release
	# FIXME rust-lang/cargo#207
	rm target/release/main
	rustc -O -L target/release/deps src/main.rs --out-dir target/release --crate-name rustic

test:
	# Use the `--run` flag to compile+execute a rust source file
	$(RUSTIC) -O --run examples/hello.rs
	# Note the shebang!
	cat examples/hello.rs
	# Execute a rust file!
	examples/hello.rs
	# Arguments before `--run` are passed to `rustc`
	# (the crate file path is always passed to `rustc`, regardless of its position)
	$(RUSTIC) --test --run examples/fib.rs
	# Arguments after `--run` are passed to the produced executable
	# (the crate file path is never passed to the executable)
	$(RUSTIC) examples/fib.rs -O --test --run --bench
	# How does it work you ask? See for yourself!
	RUST_LOG=rustic=info $(RUSTIC) -O --test --run --bench examples/fib.rs
	# If the `--run` flag is absent, `rustic` behaves just like `rustc`
	$(RUSTIC) examples/hello.rs && ./hello && rm hello
