require("source-map-support").install();
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var request, fs, jconv, folder, host, urls, download_html, name, url;
	request = __webpack_require__(1);
	fs = __webpack_require__(2);
	jconv = __webpack_require__(3);
	folder = "./raw/";
	host = "http://aigis.gcwiki.info";
	urls = {
	  melee: '/?%B6%E1%C0%DC%B7%BF',
	  range: '/?%B1%F3%B5%F7%CE%A5%B7%BF',
	  sapphire: '/?%C6%C3%BC%EC%A5%EC%A5%A2',
	  black: '/?%A5%D6%A5%E9%A5%C3%A5%AF',
	  platinum: '/?%A5%D7%A5%E9%A5%C1%A5%CA',
	  golden: '/?%A5%B4%A1%BC%A5%EB%A5%C9',
	  silver: '/?%A5%B7%A5%EB%A5%D0%A1%BC',
	  bronze: '/?%A5%D6%A5%ED%A5%F3%A5%BA',
	  iron: '/?%A5%A2%A5%A4%A5%A2%A5%F3'
	};
	download_html = function(name, url){
	  return request.get({
	    url: host + url,
	    encoding: null
	  }, function(err, resp, body){
	    var buffer;
	    buffer = jconv.convert(body, 'EUCJP', 'UTF8');
	    return fs.writeFile(folder + name + ".html", buffer.toString(), function(err){
	      return console.log(name + ".html finished!");
	    });
	  });
	};
	for (name in urls) {
	  url = urls[name];
	  download_html(name, url);
	}
	//# sourceMappingURL=/home/swind/Program/JavaScript/Senne/node_modules/livescript-loader/index.js!/home/swind/Program/JavaScript/Senne/parser/raw.ls.map


/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = require("request");

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports = require("fs");

/***/ },
/* 3 */
/***/ function(module, exports) {

	module.exports = require("jconv");

/***/ }
/******/ ]);
//# sourceMappingURL=crawler.js.map