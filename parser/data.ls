/*================================================================
*
*   Utils 
*
*================================================================*/
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

/*================================================================
*
*   Data modules 
*
*================================================================*/
class Char
    (name)->
        @name = name
        @class_type = ""
        @type = ""
        @rare = ""
        @rare_lv = 0
        @img = ""

        @class_list = []

    add_class_data: (class_data)->
        if @class_list.length == 0
            @class_type = class_data.name.replace("下級", "")

        @class_list[*] = class_data


class ClassData
    (name, min, max, resist, block, range, max_cost, min_cost, bonus, skill_1, skill_2, skill_3="")->
        @name = name
        @min = min
        @max = max
        @resist = to_number resist
        @block = to_number block
        @range = to_number range
        @max_cost = to_number max_cost
        @min_cost = to_number min_cost
        @bonus = bonus
        @skill_1 = escape skill_1
        @skill_2 = escape skill_2
        @skill_3 = escape skill_3

class LvData
    (lv, hp, at, def)->
        @lv = to_number lv
        @hp = to_number hp
        @at = to_number at
        @def = to_number def

class Bonus
    (bonus)->
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

        for item in bonus.split ";"
            for key, value of type_list
                if item.indexOf(key) == 0
                    @[value] = to_number item.replace(key, "")

module.exports = {
    "Char": Char
    "ClassData": ClassData
    "LvData": LvData
    "Bonus": Bonus
}
