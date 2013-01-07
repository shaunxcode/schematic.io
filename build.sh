coffee --compile --output lib/ src/
rm src/less/variables.less
coffee json2less.coffee > src/less/variables.less
lessc src/App.less lib/App.css
rm src/less/variables.less
component install
component build
cp build/build.js public/js/schematic.io.js
cp build/build.css public/css/schematic.io.css

rm -rf build
rm -rf lib
