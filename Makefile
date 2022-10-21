all: base tools dist upload

# Build base dependencies
base:
	docker build -f Dockerfile.base -t "open_eda_builder/base" .

# Build tools
# TODO may need to delete existing image to force rebuild (or bump version number)
tools:
	docker build -f Dockerfile -t "open_eda_builder" .

# Extract build archive out of image
# Source: https://stackoverflow.com/a/34093828/5007892
dist:
	docker run --rm --entrypoint cat open_eda_builder:latest /build/open_eda_builder.tar.zst > open_eda_builder.tar.zst

# Upload to GitHub
upload:
	gh release create -n "This build was automatically generated on $(shell date -I) (AEST time)." "$(shell date -I)"
	gh release upload "$(shell date -I)" open_eda_builder.tar.zst

# Remove archive
clean:
	rm open_eda_builder.tar.zst