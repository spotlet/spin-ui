
STYL = ./node_modules/.bin/styl
COMP = ./node_modules/.bin/component
SERVE = ./node_modules/.bin/serve

STYLS = $(wildcard styl/*)

.PHONY: build
build: clean styl component css js font

.PHONY: styl
styl: $(STYLS)

.PHONY: component
component: $(COMPONENTS)
	@mkdir -p build/component
	$(COMP) install
	node bundle

.PHONY: $(STYLS)
$(STYLS):
	@mkdir -p build/styl
	$(STYL) -w < $(@) > build/styl/$(shell basename $(@:.styl=.css))

.PHONY: js
js:
	@mkdir -p build/js
	rm -f build/spin.js
	{ ls js/* 2>/dev/null && cp js/* build/js; } || true
	{ cat build/js/* >> build/spin.js; } || true
	{ cat build/component/* >> build/spin.js; } || true

.PHONY: css
css:
	@mkdir -p build/css
	rm -f build/spin.css
	{ cat build/css/* >> build/spin.css; } || true
	{ cat build/styl/* >> build/spin.css; } || true
	{ cat build/component/*.css >> build/spin.css; } || true
	cp css/* build/css

clean:
	rm -rf build

dist: build
	rm -rf public
	mkdir public
	cp build/spin.* public/
	cp font/* public/

.PHONY: index.html
serve: index.html
index.html:
	open 'http://localhost:3000'
	$(SERVE)

