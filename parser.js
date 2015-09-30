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

	var fs, cheerio, Data, char_list, rare_name_list, read_data, update_rare, melee_list;
	fs = __webpack_require__(2);
	cheerio = __webpack_require__(4);
	Data = __webpack_require__(5);
	/*================================================================
	*
	*   Global variables 
	*
	*================================================================*/
	char_list = [];
	rare_name_list = {
	  iron: ["アイアン", 1],
	  bronze: ["ブロンズ", 2],
	  silver: ["シルバー", 3],
	  golden: ["ゴールド", 4],
	  platinum: ["プラチナ", 5],
	  black: ["ブラック", 6],
	  sapphire: ["サファイア", 7]
	};
	/*================================================================
	*
	*   Parser 
	*
	*================================================================*/
	read_data = function(filename, container, callback){
	  var data_folder;
	  data_folder = "raw/";
	  return fs.readFile(data_folder + filename, function(err, data){
	    var $;
	    if (err) {
	      throw err;
	    }
	    $ = cheerio.load(data.toString());
	    $('table.floatLeft').each(function(i, elem){
	      var status_table, name_table, name, ref$, char, img, i$, to$, min, max, class_name, min_lv, min_lv_status, min_hp, min_at, min_def, min_lv_data, resist, block_range, block, range, max_cost, min_cost, bonus, skill_1, skill_2, max_lv, max_lv_status, max_hp, max_at, max_def, max_lv_data, skill_3, class_data;
	      status_table = $(elem).find('tr');
	      name_table = status_table[0];
	      name = $((ref$ = $(name_table).find("a.load").nextAll())[ref$.length - 1]).text();
	      char = new Data.Char(name);
	      img = $(elem).find("a.load img").attr('src');
	      char.img = img;
	      for (i$ = 0, to$ = status_table.length - 1; i$ <= to$; i$ += 2) {
	        i = i$;
	        min = status_table[i];
	        max = status_table[i + 1];
	        class_name = $((ref$ = $(min).find('td[style="text-align:center; width:100px;"]'))[ref$.length - 1]).text();
	        $(min).find("br").text(";");
	        min_lv = $(min).find('td[style="width:40px;"]');
	        min_lv_status = $(min_lv).nextAll();
	        min_hp = $(min_lv_status[0]).text();
	        min_at = $(min_lv_status[1]).text();
	        min_def = $(min_lv_status[2]).text();
	        min_lv_data = new Data.LvData(min_lv.text(), min_hp, min_at, min_def);
	        resist = $(min_lv_status[3]).text();
	        block_range = $(min_lv_status[4]).text().trim().split(";");
	        if (block_range.length > 1) {
	          if (deepEq$(block_range[1].lastIndexOf('+', 0), 0, '===') || deepEq$(block_range[1].lastIndexOf('-', 0), 0, '===')) {
	            block = "";
	            range = block_range[0];
	          } else {
	            block = block_range[0];
	            range = block_range[1];
	          }
	        } else if (parseInt(block_range[0]) > 10) {
	          block = "";
	          range = block_range[0];
	        } else {
	          block = block_range[0];
	          range = "";
	        }
	        max_cost = $(min_lv_status[5]).text();
	        min_cost = $(min_lv_status[6]).text();
	        bonus = $(min_lv_status[7]).text();
	        bonus = new Data.Bonus(bonus);
	        skill_1 = $(min_lv_status[8]).text();
	        skill_2 = $(min_lv_status[9]).text();
	        $(max).find("br").text(";");
	        max_lv = $(max).find('td[style="width:40px;"]');
	        max_lv_status = $(max_lv).nextAll();
	        max_hp = $(max_lv_status[0]).text();
	        max_at = $(max_lv_status[1]).text();
	        max_def = $(max_lv_status[2]).text();
	        max_lv_data = new Data.LvData(max_lv.text(), max_hp, max_at, max_def);
	        if (max_lv_status.length > 3) {
	          skill_3 = $(max_lv_status[3]).text();
	        } else {
	          skill_3 = "";
	        }
	        class_data = new Data.ClassData(class_name, min_lv_data, max_lv_data, resist, block, range, max_cost, min_cost, bonus, skill_1, skill_2, skill_3);
	        char.add_class_data(class_data);
	      }
	      if (char.name && char.name !== "(プレイヤー名)") {
	        return container[container.length] = char;
	      }
	    });
	    return callback();
	  });
	};
	/*================================================================
	*
	*   Main
	*
	*================================================================*/
	update_rare = function(rare_name, rare_jp_name, rare_lv, collection){
	  var rare_list;
	  rare_list = [];
	  return new Promise(function(resolve, reject){
	    return read_data(rare_name + ".html", rare_list, function(){
	      var i$, ref$, len$, rare_item, j$, ref1$, len1$, char;
	      for (i$ = 0, len$ = (ref$ = rare_list).length; i$ < len$; ++i$) {
	        rare_item = ref$[i$];
	        for (j$ = 0, len1$ = (ref1$ = char_list).length; j$ < len1$; ++j$) {
	          char = ref1$[j$];
	          if (char.name === rare_item.name && rare_item.name && char) {
	            char.rare = rare_jp_name;
	            char.rare_lv = rare_lv;
	          }
	        }
	      }
	      return resolve(rare_list);
	    });
	  });
	};
	melee_list = [];
	read_data('melee.html', melee_list, function(){
	  var i$, ref$, len$, char, range_list;
	  for (i$ = 0, len$ = (ref$ = melee_list).length; i$ < len$; ++i$) {
	    char = ref$[i$];
	    char.type = 'melee';
	    char_list[char_list.length] = char;
	  }
	  range_list = [];
	  return read_data('range.html', range_list, function(){
	    var i$, ref$, len$, char, tasks, res$, rare_name, ref1$, rare_jp_name, rare_lv;
	    for (i$ = 0, len$ = (ref$ = range_list).length; i$ < len$; ++i$) {
	      char = ref$[i$];
	      if (char.class_list[0].range !== 0) {
	        char.type = 'range';
	      } else {
	        char.type = 'melee';
	      }
	      char_list[char_list.length] = char;
	    }
	    res$ = [];
	    for (rare_name in ref$ = rare_name_list) {
	      ref1$ = ref$[rare_name], rare_jp_name = ref1$[0], rare_lv = ref1$[1];
	      res$.push(update_rare(rare_name, rare_jp_name, rare_lv, char_list));
	    }
	    tasks = res$;
	    return Promise.all(tasks).then(function(value){
	      return fs.writeFile('sennen.json', JSON.stringify(char_list, "utf-8"), function(err){
	        if (err) {
	          return console.log(err);
	        }
	        return console.log("Done!");
	      });
	    });
	  });
	});
	function deepEq$(x, y, type){
	  var toString = {}.toString, hasOwnProperty = {}.hasOwnProperty,
	      has = function (obj, key) { return hasOwnProperty.call(obj, key); };
	  var first = true;
	  return eq(x, y, []);
	  function eq(a, b, stack) {
	    var className, length, size, result, alength, blength, r, key, ref, sizeB;
	    if (a == null || b == null) { return a === b; }
	    if (a.__placeholder__ || b.__placeholder__) { return true; }
	    if (a === b) { return a !== 0 || 1 / a == 1 / b; }
	    className = toString.call(a);
	    if (toString.call(b) != className) { return false; }
	    switch (className) {
	      case '[object String]': return a == String(b);
	      case '[object Number]':
	        return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
	      case '[object Date]':
	      case '[object Boolean]':
	        return +a == +b;
	      case '[object RegExp]':
	        return a.source == b.source &&
	               a.global == b.global &&
	               a.multiline == b.multiline &&
	               a.ignoreCase == b.ignoreCase;
	    }
	    if (typeof a != 'object' || typeof b != 'object') { return false; }
	    length = stack.length;
	    while (length--) { if (stack[length] == a) { return true; } }
	    stack.push(a);
	    size = 0;
	    result = true;
	    if (className == '[object Array]') {
	      alength = a.length;
	      blength = b.length;
	      if (first) {
	        switch (type) {
	        case '===': result = alength === blength; break;
	        case '<==': result = alength <= blength; break;
	        case '<<=': result = alength < blength; break;
	        }
	        size = alength;
	        first = false;
	      } else {
	        result = alength === blength;
	        size = alength;
	      }
	      if (result) {
	        while (size--) {
	          if (!(result = size in a == size in b && eq(a[size], b[size], stack))){ break; }
	        }
	      }
	    } else {
	      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) {
	        return false;
	      }
	      for (key in a) {
	        if (has(a, key)) {
	          size++;
	          if (!(result = has(b, key) && eq(a[key], b[key], stack))) { break; }
	        }
	      }
	      if (result) {
	        sizeB = 0;
	        for (key in b) {
	          if (has(b, key)) { ++sizeB; }
	        }
	        if (first) {
	          if (type === '<<=') {
	            result = size < sizeB;
	          } else if (type === '<==') {
	            result = size <= sizeB
	          } else {
	            result = size === sizeB;
	          }
	        } else {
	          first = false;
	          result = size === sizeB;
	        }
	      }
	    }
	    stack.pop();
	    return result;
	  }
	}
	//# sourceMappingURL=/home/swind/Program/JavaScript/Senne/node_modules/livescript-loader/index.js!/home/swind/Program/JavaScript/Senne/parser/sennen.ls.map


/***/ },
/* 1 */,
/* 2 */
/***/ function(module, exports) {

	module.exports = require("fs");

/***/ },
/* 3 */,
/* 4 */
/***/ function(module, exports) {

	module.exports = require("cheerio");

/***/ },
/* 5 */
/***/ function(module, exports) {

	/*================================================================
	*
	*   Utils 
	*
	*================================================================*/
	var escape, to_number, Char, ClassData, LvData, Bonus;
	escape = function(char){
	  return char.replace(/Lv|\*|-|ランク200/, "");
	};
	to_number = function(char){
	  var clean_char, result;
	  clean_char = escape(char);
	  if (clean_char.trim()) {
	    result = parseInt(clean_char);
	  } else {
	    result = 0;
	  }
	  if (deepEq$(result, NaN, '===')) {
	    console.log("to_number failed:", char);
	  }
	  return result;
	};
	/*================================================================
	*
	*   Data modules 
	*
	*================================================================*/
	Char = (function(){
	  Char.displayName = 'Char';
	  var prototype = Char.prototype, constructor = Char;
	  function Char(name){
	    this.name = name;
	    this.class_type = "";
	    this.type = "";
	    this.rare = "";
	    this.rare_lv = 0;
	    this.img = "";
	    this.class_list = [];
	  }
	  prototype.add_class_data = function(class_data){
	    var ref$;
	    if (this.class_list.length === 0) {
	      this.class_type = class_data.name.replace("下級", "");
	    }
	    return (ref$ = this.class_list)[ref$.length] = class_data;
	  };
	  return Char;
	}());
	ClassData = (function(){
	  ClassData.displayName = 'ClassData';
	  var prototype = ClassData.prototype, constructor = ClassData;
	  function ClassData(name, min, max, resist, block, range, max_cost, min_cost, bonus, skill_1, skill_2, skill_3){
	    skill_3 == null && (skill_3 = "");
	    this.name = name;
	    this.min = min;
	    this.max = max;
	    this.resist = to_number(resist);
	    this.block = to_number(block);
	    this.range = to_number(range);
	    this.max_cost = to_number(max_cost);
	    this.min_cost = to_number(min_cost);
	    this.bonus = bonus;
	    this.skill_1 = escape(skill_1);
	    this.skill_2 = escape(skill_2);
	    this.skill_3 = escape(skill_3);
	  }
	  return ClassData;
	}());
	LvData = (function(){
	  LvData.displayName = 'LvData';
	  var prototype = LvData.prototype, constructor = LvData;
	  function LvData(lv, hp, at, def){
	    this.lv = to_number(lv);
	    this.hp = to_number(hp);
	    this.at = to_number(at);
	    this.def = to_number(def);
	  }
	  return LvData;
	}());
	Bonus = (function(){
	  Bonus.displayName = 'Bonus';
	  var prototype = Bonus.prototype, constructor = Bonus;
	  function Bonus(bonus){
	    var type_list, i$, ref$, len$, item, key, value;
	    this.hp = 0;
	    this.at = 0;
	    this.def = 0;
	    this.stun = 0;
	    type_list = {
	      "HP+": 'hp',
	      "攻撃力+": 'at',
	      "防御力+": 'def',
	      "攻撃硬直-": 'stun'
	    };
	    for (i$ = 0, len$ = (ref$ = bonus.split(";")).length; i$ < len$; ++i$) {
	      item = ref$[i$];
	      for (key in type_list) {
	        value = type_list[key];
	        if (item.indexOf(key) === 0) {
	          this[value] = to_number(item.replace(key, ""));
	        }
	      }
	    }
	  }
	  return Bonus;
	}());
	module.exports = {
	  "Char": Char,
	  "ClassData": ClassData,
	  "LvData": LvData,
	  "Bonus": Bonus
	};
	function deepEq$(x, y, type){
	  var toString = {}.toString, hasOwnProperty = {}.hasOwnProperty,
	      has = function (obj, key) { return hasOwnProperty.call(obj, key); };
	  var first = true;
	  return eq(x, y, []);
	  function eq(a, b, stack) {
	    var className, length, size, result, alength, blength, r, key, ref, sizeB;
	    if (a == null || b == null) { return a === b; }
	    if (a.__placeholder__ || b.__placeholder__) { return true; }
	    if (a === b) { return a !== 0 || 1 / a == 1 / b; }
	    className = toString.call(a);
	    if (toString.call(b) != className) { return false; }
	    switch (className) {
	      case '[object String]': return a == String(b);
	      case '[object Number]':
	        return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
	      case '[object Date]':
	      case '[object Boolean]':
	        return +a == +b;
	      case '[object RegExp]':
	        return a.source == b.source &&
	               a.global == b.global &&
	               a.multiline == b.multiline &&
	               a.ignoreCase == b.ignoreCase;
	    }
	    if (typeof a != 'object' || typeof b != 'object') { return false; }
	    length = stack.length;
	    while (length--) { if (stack[length] == a) { return true; } }
	    stack.push(a);
	    size = 0;
	    result = true;
	    if (className == '[object Array]') {
	      alength = a.length;
	      blength = b.length;
	      if (first) {
	        switch (type) {
	        case '===': result = alength === blength; break;
	        case '<==': result = alength <= blength; break;
	        case '<<=': result = alength < blength; break;
	        }
	        size = alength;
	        first = false;
	      } else {
	        result = alength === blength;
	        size = alength;
	      }
	      if (result) {
	        while (size--) {
	          if (!(result = size in a == size in b && eq(a[size], b[size], stack))){ break; }
	        }
	      }
	    } else {
	      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) {
	        return false;
	      }
	      for (key in a) {
	        if (has(a, key)) {
	          size++;
	          if (!(result = has(b, key) && eq(a[key], b[key], stack))) { break; }
	        }
	      }
	      if (result) {
	        sizeB = 0;
	        for (key in b) {
	          if (has(b, key)) { ++sizeB; }
	        }
	        if (first) {
	          if (type === '<<=') {
	            result = size < sizeB;
	          } else if (type === '<==') {
	            result = size <= sizeB
	          } else {
	            result = size === sizeB;
	          }
	        } else {
	          first = false;
	          result = size === sizeB;
	        }
	      }
	    }
	    stack.pop();
	    return result;
	  }
	}
	//# sourceMappingURL=/home/swind/Program/JavaScript/Senne/node_modules/livescript-loader/index.js!/home/swind/Program/JavaScript/Senne/parser/data.ls.map


/***/ }
/******/ ]);
//# sourceMappingURL=parser.js.map