.PHONY: generate open test clean setup

# Generate Xcode project from project.yml
generate:
	xcodegen generate

# Generate and open in Xcode
open: generate
	open LanguageLens.xcodeproj

# Run tests via xcodebuild
test:
	xcodebuild test \
		-project LanguageLens.xcodeproj \
		-scheme LanguageLens \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		-quiet

# Build all Swift packages independently
test-packages:
	@for pkg in Packages/*/; do \
		echo "Testing $$pkg..."; \
		cd $$pkg && swift test && cd ../..; \
	done

# Clean build artifacts
clean:
	rm -rf DerivedData build .build
	xcodebuild clean -project LanguageLens.xcodeproj -scheme LanguageLens 2>/dev/null || true

# First-time setup
setup:
	@echo "Installing dependencies..."
	brew install xcodegen || true
	@echo "Generating Xcode project..."
	xcodegen generate
	@echo ""
	@echo "Setup complete. Run 'make open' to open in Xcode."
