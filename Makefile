install:
	swift build -c release
	install .build/release/espressomartini-cli /usr/local/bin/espressomartini
