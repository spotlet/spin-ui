
STYL = ./node_modules/.bin/styl
COMP = ./node_modules/.bin/component
SERVE = ./node_modules/.bin/serve

STYLS = $(wildcard styl/*)

dist: build
	rm -rf public
	mkdir -p public
	mkdir -p public/{js,css,fonts}
	cp build/*.css public/css
	cp build/*.js public/js
	cp fonts/* public/fonts

.PHONY: build
build: styl component css js

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
js: component
	@mkdir -p build/js
	rm -f build/spin.js
	{ ls js/* 2>/dev/null && cp js/* build/js; } || true
	{ cat build/js/* >> build/spin.js; } || true
	{ cat build/component/* >> build/spin.js; } || true

.PHONY: css
css: $(STYLS)
	@mkdir -p build/css
	rm -f build/spin.css
	{ cat build/css/* >> build/spin.css; } || true
	{ cat build/styl/* >> build/spin.css; } || true
	{ cat build/component/*.css >> build/spin.css; } || true
	cp css/* build/css

clean:
	rm -rf build

.PHONY: index.html
serve: index.html
index.html:
	open 'http://localhost:3000'
	$(SERVE)

