COMMONFORM=node_modules/.bin/commonform
BUILD=build
TARGETS=$(addprefix $(BUILD)/,$(addprefix document,.docx .pdf))

all: $(TARGETS)

# See the GNU Make Manual on "order-only-prerequisites"
$(TARGETS): | $(BUILD)

$(BUILD):
	mkdir $(BUILD)

$(BUILD)/document.docx: document.cform signatures.json blanks.json $(COMMONFORM)
	$(COMMONFORM) render -f docx --title "Document Title" --number outline -s signatures.json -b blanks.json $< > $@

%.pdf: %.docx
	doc2pdf $<

$(COMMONFORM):
	npm install

.PHONY: clean docker

clean:
	rm -rf $(BUILD)

DOCKER_TAG=one-commonform-document

docker:
	docker build -t $(DOCKER_TAG) .
	docker run --name $(DOCKER_TAG) $(DOCKER_TAG)
	docker cp $(DOCKER_TAG):/workdir/$(BUILD) .
	docker rm $(DOCKER_TAG)
