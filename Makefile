
STYL = ./node_modules/.bin/styl
COMP = ./node_modules/.bin/component

STYLS = $(wildcard styl/*)

.PHONY: build
build: clean styl component

.PHONY: styl
styl: $(STYLS)
	mkdir -p build/css

.PHONY: component
component: $(COMPONENTS)
	mkdir -p build/js
	$(COMP) install
	node bundle
	$(foreach bundle, $(wildcard component/build/*.js), \
		$(shell ln -sf $(CWD)/$(bundle) public/js/$(shell basename $(bundle))))
	$(foreach bundle, $(wildcardard component/build/*.css), \
		$(shell ln -sf $(CWD)/$(bundle) \
		public/bundlecss/component-$(shell basename $(bundle))))

$(STYLS):
	$(STYL) -w < $(@) > build/css/$(shell basename $(@:.styl=.css))

clean:
	rm -rf build

