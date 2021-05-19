include boilerplate/generated-includes.mk

.PHONY: boilerplate-update
boilerplate-update:
	@boilerplate/update

SHELL := /usr/bin/env bash

FORWARDER_VERSION ?= 8.0.5
FORWARDER_HASH ?= a1a6394cc5ae
SFI_HASH_7 ?= fa50892

FORWARDER_IMAGE_TAG=$(FORWARDER_VERSION)-$(FORWARDER_HASH)-$(SFI_HASH_7)

FORWARDER_NAME=splunk-forwarder
FORWARDER_IMAGE_URI=$(IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(FORWARDER_NAME):$(FORWARDER_IMAGE_TAG)

HEAVYFORWARDER_NAME=splunk-heavyforwarder
HEAVYFORWARDER_IMAGE_URI=$(IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(HEAVYFORWARDER_NAME):$(FORWARDER_IMAGE_TAG)

## Convenience targets for local dev. Duplicates are for consistent naming.

.PHONY: build-operator
build-operator: docker-build

.PHONY: push-operator
push-operator: docker-push

.PHONY: image-digests
image-digests:
	./hack/populate-image-digests.sh "$(FORWARDER_IMAGE_URI)" "$(HEAVYFORWARDER_IMAGE_URI)"

.PHONY: vuln-check
vuln-check: build-operator
	./hack/check-image-against-osd-sre-clair.sh $(OPERATOR_IMAGE_URI)

.PHONY: image-update
image-update:
	./hack/update-image-vars.sh $(SFI_UPDATE)
