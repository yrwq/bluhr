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
	@echo "Archiving $(PROJECT_NAME)..."
	$(XCODEBUILD) \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration Release \
		-destination $(DESTINATION) \
		-derivedDataPath $(DERIVED_DATA) \
		archive \
		-archivePath $(ARCHIVE_PATH)

.PHONY: export
export: archive
	@echo "Exporting $(PROJECT_NAME)..."
	$(XCODEBUILD) \
		-exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(EXPORT_PATH) \
		-exportOptionsPlist exportOptions.plist