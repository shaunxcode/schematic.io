var map = require('./map');

module.exports.timestamp = function (from) {
  if(!from) from = 1328054400000; //2012/1/1
  
  var timestamp = (new Date().getTime() - from).toString().split('');
  var elements = [];
  var hash = '';
  
  for(var i = 0; i < timestamp.length; i += 1) {
    if(i%2 === 0) elements.push(timestamp[i]);
    else elements[elements.length -1] += timestamp[i];
  }
  
  for(var y = 0; y < elements.length; y += 1) {
    hash += map[elements[y]];
  }
  
  return hash;
}

module.exports.random = function (length) {
  if(!length) length = 6;
  
  var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'.split('');
  var hash = [];

  for(var i = 0; i < length; i += 1) {
    hash.push(chars[Math.floor(Math.random()*62)]);
  }

  return hash.join('');
};