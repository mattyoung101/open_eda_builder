all: base tools dist upload

# Build base dependencies
base:
	docker build -f Dockerfile.base -t "open_eda_builder/base" .

# Build the actual EDA tools. We also delete the "open_eda_builder" image to force a rebuild.
# Note the - in front of the docker image rm is to discard errors: https://stackoverflow.com/a/2670143/5007892
# We also need to change the Docker output for debugging: https://www.reddit.com/r/docker/comments/m7t1q4/comment/hwpata8/
# TODO find a better way of pruning only open_eda_builder related images instead of docker image prune -f (which is bad)
tools:
	-docker image rm -f "open_eda_builder"
	docker image prune -f
	docker build -f Dockerfile -t "open_eda_builder"  .

# Extract build archive out of image
# Source: https://stackoverflow.com/a/34093828/5007892
dist:
	docker run --rm --entrypoint cat open_eda_builder:latest /build/open_eda_builder.tar.zst > open_eda_builder.tar.zst

# Upload to GitHub
upload:
	gh release create -n "This build was automatically generated on $(shell date -I) (AEST)" -t "$(shell date -I)" "$(shell date -I)"
	gh release upload "$(shell date -I)" open_eda_builder.tar.zst

# Remove archive
clean:
	rm open_eda_builder.tar.zst