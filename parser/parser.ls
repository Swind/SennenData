require! {
    "fs": fs
    "cheerio": cheerio
    "./data.ls": Data
}

/*================================================================
*
*   Global variables 
*
*================================================================*/

char_list = []

rare_name_list = {
    iron: ["アイアン", 1]
    bronze: ["ブロンズ", 2]
    silver: ["シルバー", 3]
    golden: ["ゴールド", 4]
    platinum: ["プラチナ", 5]
    black: ["ブラック", 6]
    sapphire: ["サファイア", 7]
}

/*================================================================
*
*   Parser 
*
*================================================================*/
read_data = (filename, container, callback) ->

    data_folder = "raw/"

    (err, data) <- fs.readFile data_folder + filename

    # Read file
    if err
        throw err

    $ = cheerio.load data.toString!

    # Parse html
    $(\table.floatLeft).each (i, elem) ->

        status_table = $(elem).find(\tr)

        name_table = status_table[0]
        name = $($(name_table).find("a.load").nextAll![*-1])text!

        char = new Data.Char name

        img = $(elem).find("a.load img").attr \src
        char.img = img

        for i to status_table.length - 1 by 2
            min = status_table[i]
            max = status_table[i+1]

            class_name = $($(min).find('td[style="text-align:center; width:100px;"]')[*-1]).text!

            # Min LV 
            $(min).find("br").text(";")
            min_lv = $(min).find('td[style="width:40px;"]')
            min_lv_status = $(min_lv).nextAll! 
            min_hp = $(min_lv_status[0]).text!
            min_at = $(min_lv_status[1]).text!
            min_def = $(min_lv_status[2]).text!
            min_lv_data = new Data.LvData min_lv.text!, min_hp, min_at, min_def

            # Class status
            resist = $(min_lv_status[3]).text!

            block_range = $(min_lv_status[4]).text!.trim!.split ";"

            # If there are two value in block or range field
            if block_range.length > 1
                # If the second value start with +, the first value is range
                if block_range[1].lastIndexOf(\+, 0) === 0 or block_range[1].lastIndexOf(\-, 0) === 0
                    block = ""
                    range = block_range[0]
                else
                    block = block_range[0]
                    range = block_range[1]

            # If there are one value, 
            # the value smaller than 10 is block otherwise is range
            else if parseInt(block_range[0]) > 10
                block = ""
                range = block_range[0]
            else
                block = block_range[0]
                range = ""


            max_cost = $(min_lv_status[5]).text!
            min_cost = $(min_lv_status[6]).text!

            bonus = $(min_lv_status[7]).text!
            bonus = new Data.Bonus(bonus)

            skill_1 = $(min_lv_status[8]).text!
            skill_2 = $(min_lv_status[9]).text!

            # Max LV 
            $(max).find("br").text(";")
            max_lv = $(max).find('td[style="width:40px;"]')
            max_lv_status = $(max_lv).nextAll!
            max_hp = $(max_lv_status[0]).text!
            max_at = $(max_lv_status[1]).text!
            max_def = $(max_lv_status[2]).text!
            max_lv_data = new Data.LvData max_lv.text!, max_hp, max_at, max_def

            if max_lv_status.length > 3
                skill_3 = $(max_lv_status[3]).text!
            else
                skill_3 = ""

            class_data = new Data.ClassData class_name,
                                       min_lv_data,
                                       max_lv_data,
                                       resist,
                                       block,
                                       range,
                                       max_cost,
                                       min_cost,
                                       bonus,
                                       skill_1,
                                       skill_2,
                                       skill_3

            char.add_class_data class_data

        # Filter 王子 and empty data
        if char.name and char.name != "(プレイヤー名)"
            container[*] = char

    callback!

/*================================================================
*
*   Main
*
*================================================================*/

update_rare = (rare_name, rare_jp_name, rare_lv, collection) ->
    rare_list = []

    new Promise (resolve, reject) ->
        <- read_data rare_name + ".html", rare_list

        for rare_item in rare_list
            for char in char_list
                if char.name == rare_item.name and rare_item.name and char
                    char.rare = rare_jp_name
                    char.rare_lv = rare_lv

        resolve rare_list

# Read melee data
melee_list = []
<- read_data \melee.html, melee_list
for char in melee_list
    char.type = \melee
    char_list[*] = char

# Read range data
range_list = []
<- read_data \range.html, range_list
for char in range_list

    # Filter the summon
    if char.class_list[0].range != 0
        char.type = \range
    else
        char.type = \melee

    char_list[*] = char


# Read rare data and merge that
tasks = for rare_name, [rare_jp_name, rare_lv] of rare_name_list
            update_rare(rare_name, rare_jp_name, rare_lv, char_list)

# Wait all rare data merge finished
(value) <- Promise.all(tasks).then

# Save char to json file
(err) <- fs.writeFile \sennen.json, JSON.stringify char_list, "utf-8"

if err
    return console.log err

console.log "Done!"
