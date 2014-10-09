
STYL = ./node_modules/.bin/styl
COMP = ./node_modules/.bin/component
SERVE = ./node_modules/.bin/serve

STYLS = $(wildcard styl/*)

dist: out
	rm -rf public
	mkdir -p public
	mkdir -p public/{js,css,fonts}
	cp out/*.css public/css
	cp out/*.js public/js
	cp fonts/* public/fonts

.PHONY: out
out: styl component css js

.PHONY: styl
styl: $(STYLS)

.PHONY: component
component: $(COMPONENTS)
	@mkdir -p out/component
	$(COMP) install
	node bundle

.PHONY: $(STYLS)
$(STYLS):
	@mkdir -p out/styl
	$(STYL) -w < $(@) > out/styl/$(shell basename $(@:.styl=.css))

.PHONY: js
js: component
	@mkdir -p out/js
	rm -f out/spin.js
	{ ls js/* 2>/dev/null && cp js/* out/js; } || true
	{ cat out/js/* >> out/spin.js; } || true
	{ cat out/component/* >> out/spin.js; } || true

.PHONY: css
css: $(STYLS)
	@mkdir -p out/css
	rm -f out/spin.css
	{ cat out/css/* >> out/spin.css; } || true
	{ cat out/styl/* >> out/spin.css; } || true
	{ cat out/component/*.css >> out/spin.css; } || true
	cp css/* out/css

clean:
	rm -rf out

.PHONY: index.html
serve: index.html
index.html:
	open 'http://localhost:3000'
	$(SERVE)

