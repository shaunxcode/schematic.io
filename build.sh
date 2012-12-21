coffee --compile --output lib/ src/
lessc src/App.less lib/App.css
component install
component build
cp build/build.js public/js/schematic.io.js
cp build/build.css public/css/schematic.io.css
rm -rf build
rm -rf lib
