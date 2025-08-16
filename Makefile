PROJECT_NAME = bluhr
SCHEME = bluhr
CONFIGURATION = Debug
DESTINATION = platform=macOS
SDK = macosx

XCODEBUILD = xcodebuild
DERIVED_DATA = build
ARCHIVE_PATH = build/$(PROJECT_NAME).xcarchive
EXPORT_PATH = build/$(PROJECT_NAME).app

.PHONY: all
all: build

.PHONY: build
build:
	@echo "Building $(PROJECT_NAME)..."
	$(XCODEBUILD) \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination $(DESTINATION) \
		-derivedDataPath $(DERIVED_DATA) \
		build

.PHONY: release
release:
	@echo "Building $(PROJECT_NAME) for release..."
	$(XCODEBUILD) \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration Release \
		-destination $(DESTINATION) \
		-derivedDataPath $(DERIVED_DATA) \
		build

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	$(XCODEBUILD) \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		clean
	rm -rf $(DERIVED_DATA)
	rm -rf build

.PHONY: run
run: build
	@echo "Running $(PROJECT_NAME)..."
	$(XCODEBUILD) \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination $(DESTINATION) \
		-derivedDataPath $(DERIVED_DATA) \
		run

.PHONY: archive
archive:
	@echo "Creating archive for $(PROJECT_NAME)..."
	@mkdir -p build
	$(XCODEBUILD) \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration Release \
		-destination $(DESTINATION) \
		-derivedDataPath $(DERIVED_DATA) \
		archive \
		-archivePath $(ARCHIVE_PATH)
	@echo "Archive created at: $(ARCHIVE_PATH)"

.PHONY: export
export: archive
	@echo "Exporting $(PROJECT_NAME) from archive..."
	@if [ ! -f exportOptions.plist ]; then \
		echo "Creating exportOptions.plist for development build..."; \
		echo '<?xml version="1.0" encoding="UTF-8"?>'; \
		echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'; \
		echo '<plist version="1.0">'; \
		echo '<dict>'; \
		echo '	<key>method</key>'; \
		echo '	<string>mac-application</string>'; \
		echo '	<key>teamID</key>'; \
		echo '	<string>97NR87TGQ9</string>'; \
		echo '	<key>signingStyle</key>'; \
		echo '	<string>automatic</string>'; \
		echo '	<key>stripSwiftSymbols</key>'; \
		echo '	<true/>'; \
		echo '	<key>uploadBitcode</key>'; \
		echo '	<false/>'; \
		echo '	<key>uploadSymbols</key>'; \
		echo '	<false/>'; \
		echo '	<key>compileBitcode</key>'; \
		echo '	<false/>'; \
		echo '</dict>'; \
		echo '</plist>' > exportOptions.plist; \
	fi
	$(XCODEBUILD) \
		-exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(EXPORT_PATH) \
		-exportOptionsPlist exportOptions.plist
	@echo "Export completed. App available at: $(EXPORT_PATH)"

.PHONY: export-dev
export-dev: archive
	@echo "Exporting $(PROJECT_NAME) for development..."
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > exportOptions.plist
	@echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> exportOptions.plist
	@echo '<plist version="1.0">' >> exportOptions.plist
	@echo '<dict>' >> exportOptions.plist
	@echo '	<key>method</key>' >> exportOptions.plist
	@echo '	<string>mac-application</string>' >> exportOptions.plist
	@echo '	<key>signingStyle</key>' >> exportOptions.plist
	@echo '	<string>automatic</string>' >> exportOptions.plist
	@echo '</dict>' >> exportOptions.plist
	@echo '</plist>' >> exportOptions.plist
	$(XCODEBUILD) \
		-exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(EXPORT_PATH) \
		-exportOptionsPlist exportOptions.plist
	@echo "Development export completed. App available at: $(EXPORT_PATH)"

.PHONY: release-build
release-build: clean release
	@echo "Release build completed successfully!"

.PHONY: full-release
full-release: clean archive export
	@echo "Full release process completed!"
	@echo "Archive: $(ARCHIVE_PATH)"
	@echo "App: $(EXPORT_PATH)"

.PHONY: dev-release
dev-release: clean archive export-dev
	@echo "Development release completed!"
	@echo "Archive: $(ARCHIVE_PATH)"
	@echo "App: $(EXPORT_PATH)"

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all           - Build the project (default)"
	@echo "  build         - Build the project in Debug mode"
	@echo "  release       - Build the project in Release mode"
	@echo "  clean         - Clean build artifacts"
	@echo "  run           - Build and run the app"
	@echo "  archive       - Create archive for distribution"
	@echo "  export        - Export app from archive (with team ID)"
	@echo "  export-dev    - Export app for development (no team ID)"
	@echo "  release-build - Clean and build release version"
	@echo "  full-release  - Complete release process (clean, archive, export)"
	@echo "  dev-release   - Development release (clean, archive, export-dev)"
	@echo "  help          - Show this help message"