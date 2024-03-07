.PHONY: check
check:
	$(MAKE) -C runners/embedded check-all
	$(MAKE) -C runners/nkpk check
	$(MAKE) -C runners/usbip check

.PHONY: doc
doc: 
	$(MAKE) -C runners/embedded doc-nk3am
	
.PHONY: lint
lint:
	cargo fmt -- --check
	$(MAKE) -C runners/embedded lint-all
	$(MAKE) -C runners/nkpk lint
	$(MAKE) -C runners/usbip lint

.PHONY: binaries
binaries:
	mkdir -p binaries
	$(MAKE) -C runners/embedded build-all FEATURES=
	cp runners/embedded/artifacts/runner-lpc55-nk3xn.bin binaries/firmware-nk3xn.bin
	cp runners/embedded/artifacts/runner-nrf52-bootloader-nk3am.bin.ihex binaries/firmware-nk3am.ihex
	$(MAKE) -C runners/embedded build-all FEATURES=provisioner
	cp runners/embedded/artifacts/runner-lpc55-nk3xn.bin binaries/provisioner-nk3xn.bin
	cp runners/embedded/artifacts/runner-nrf52-bootloader-nk3am.bin.ihex binaries/provisioner-nk3am.ihex
	$(MAKE) -C runners/embedded build-all FEATURES=test
	cp runners/embedded/artifacts/runner-lpc55-nk3xn.bin binaries/firmware-nk3xn-test.bin
	cp runners/embedded/artifacts/runner-nrf52-bootloader-nk3am.bin.ihex binaries/firmware-nk3am-test.ihex
	$(MAKE) -C runners/nkpk build
	cp runners/nkpk/artifacts/runner-nkpk.bin.ihex binaries/firmware-nkpk.ihex
	$(MAKE) -C runners/nkpk build FEATURES=provisioner
	cp runners/nkpk/artifacts/runner-nkpk.bin.ihex binaries/provisioner-nkpk.ihex

license.txt:
	cargo run --release --manifest-path utils/collect-license-info/Cargo.toml -- runners/embedded/Cargo.toml "Nitrokey 3" > license.txt

commands.bd:
	cargo run --release --manifest-path utils/gen-commands-bd/Cargo.toml -- runners/embedded/Cargo.toml > $@

manifest.json:
	sed "s/@VERSION@/`git describe --always`/g" utils/manifest.template.json > manifest.json
