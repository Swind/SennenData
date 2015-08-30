require! {
    "fs": fs
    "cheerio": cheerio
    "lokijs": lokijs
}

char_list = []

escape = (char) ->
    return char.replace(/Lv|\*|-|ランク200/, "")

to_number = (char) ->
    clean_char = escape char 

    if clean_char.trim!
        result = parseInt(clean_char)
    else
        result = 0

    if result === NaN 
        console.log "to_number failed:", char 

    return result

class Char
    (name)->
        @name = name
        @class_list = []

    add_class_data: (class_data)->
        @class_list[*] = class_data


class ClassData
    (name, min, max, magic, block, range, max_cost, min_cost, favor, skill_1, skill_2, skill_3="")->
        @name = name
        @min = min
        @max = max
        @magic = to_number magic
        @block = to_number block
        @range = to_number range
        @max_cost = to_number max_cost
        @min_cost = to_number min_cost
        @favor = favor
        @skill_1 = escape skill_1
        @skill_2 = escape skill_2
        @skill_3 = escape skill_3

class LvData
    (lv, hp, at, def)->
        @lv = to_number lv
        @hp = to_number hp
        @at = to_number at
        @def = to_number def

class Favor
    (favor)->
        @hp = 0
        @at = 0
        @def = 0
        @stun = 0

        type_list = {
            "HP+": \hp 
            "攻撃力+": \at
            "防御力+": \def 
            "攻撃硬直-": \stun
        }

        for item in favor.split ";"
            for key, value of type_list
                if item.indexOf(key) == 0 
                    @[value] = to_number item.replace(key, "")  

read_data = (filename, callback) ->

    (err, data) <- fs.readFile filename 

    # Read file
    if err
        throw err

    $ = cheerio.load data.toString!

    # Parse html
    $(\table.floatLeft).each (i, elem) ->

        status_table = $(elem).find(\tr)

        name_table = status_table[0]
        name = $($(name_table).find("a.load").nextAll![*-1])text!

        char = new Char name

        for i to status_table.length - 1 by 2
            min = status_table[i]
            max = status_table[i+1]

            class_name = $(min).find('td[rowspan=2][style="text-align:center; width:100px;"]').text!

            # Min LV 
            $(min).find("br").text(";")
            min_lv = $(min).find('td[style="width:40px;"]')
            min_lv_status = $(min_lv).nextAll! 
            min_hp = $(min_lv_status[0]).text!
            min_at = $(min_lv_status[1]).text!
            min_def = $(min_lv_status[2]).text!
            min_lv_data = new LvData min_lv.text!, min_hp, min_at, min_def

            # Class status
            magic = $(min_lv_status[3]).text!

            block_range = $(min_lv_status[4]).text!.trim!.split ";"
            if block_range.length > 1 
                block = block_range[0]
                range = block_range[1]
            else if block_range[0].length > 2
                block = "" 
                range = block_range[0]
            else
                block = block_range[0]
                range = "" 

            max_cost = $(min_lv_status[5]).text!
            min_cost = $(min_lv_status[6]).text!

            favor = $(min_lv_status[7]).text!
            favor = new Favor(favor)

            skill_1 = $(min_lv_status[8]).text!
            skill_2 = $(min_lv_status[9]).text!

            # Max LV 
            $(max).find("br").text(";")
            max_lv = $(max).find('td[style="width:40px;"]')
            max_lv_status = $(max_lv).nextAll!
            max_hp = $(max_lv_status[0]).text!
            max_at = $(max_lv_status[1]).text!
            max_def = $(max_lv_status[2]).text!
            max_lv_data = new LvData max_lv.text!, max_hp, max_at, max_def

            if max_lv_status.length > 3
                skill_3 = $(max_lv_status[3]).text!
            else
                skill_3 = ""

            class_data = new ClassData class_name,
                                       min_lv_data,
                                       max_lv_data,
                                       magic,
                                       block,
                                       range,
                                       max_cost,
                                       min_cost,
                                       favor,
                                       skill_1,
                                       skill_2,
                                       skill_3

            char.add_class_data class_data

        char_list[*] = char

    callback!

<- read_data \raw_fight_data.html
<- read_data \raw_range_data.html

db = new lokijs "sennen.json"
collection = db.addCollection \char

for char in char_list
    console.log JSON.stringify char
    collection.insert char

db.save!

