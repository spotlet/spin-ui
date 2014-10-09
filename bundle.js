
/**
 * Module dependencies
 */

var fs = require('fs')
  , path = require('path')
  , build = require('component-builder')
  , resolve = require('component-resolver')
  , bundler = require('component-bundler')
  , jade = require('jade')

var opts = {root: __dirname, build: path.join(__dirname, 'out/component')};
var fwrite = fs.writeFileSync;
var json = require(path.join(opts.root, 'component.json'));
var bundle = bundler.pages(json);

/**
 * Resolve and build
 */

resolve(opts.root, {install: true}, function (err, tree) {
  var bundles = null;
  if (err) { throw err; }

  // create
  bundles = bundle(tree);

  // build
  Object.keys(bundles).forEach(function (name) {
    build.styles(bundles[name])
    .use('styles', build.plugins.css())
    .end(function (err, string) {
      if (err) throw err;
      if (string) {
        fs.writeFileSync(path.join(opts.build, name +'.css'), string);
      }
    });

    build.scripts(bundles[name])
    .use('scripts', build.plugins.js())
    .use('templates', function (file, next) {
      file.read(function (err, buf) {
        if (err) { return next(err); }
        switch (file.extension) {
          case 'jade':
            buf = jade.render(String(buf));
          break;
        }
        file.define = true;
        file.string = JSON.stringify(buf);
        next();
      });
    })
    .build(function (err, js) {
      var file = null;
      if (err) { throw err; }
      else if (!js) { return; }
      // require code
      if (name === json.locals[0] && js) {
        //js = build.scripts.require + js;
        js = build.scripts.umd('./component/boot', 'spin', js);
      }

      file = path.join(opts.build, name + '.js');
      fwrite(file, js, 'utf8');
    });
  });
})
