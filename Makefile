COMMONFORM=node_modules/.bin/commonform
BUILD=build

all: $(BUILD)/document.docx $(BUILD)/document.pdf

$(BUILD):
	mkdir $(BUILD)

$(BUILD)/document.docx: document.cform signatures.json blanks.json $(COMMONFORM) $(BUILD)
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
	docker run -v $(shell pwd)/$(BUILD):/work/$(BUILD) $(DOCKER_TAG)
	sudo chown -R `whoami` $(BUILD)
