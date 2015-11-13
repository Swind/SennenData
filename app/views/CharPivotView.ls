require! {
    "react": React
}

{div, table, thead, tbody, th, tr, td, label, input, span} = React.DOM

max_status = (name, char) -->
  console.log name
  return char.class_list[*-1].max[name]

dimensions = [
  { title:\クラス, value: \class_type }
  { title:\レア, value: \rare }
]
reduce = (row, memo) ->
  memo = row
  return memo

calculations = [ 
  { title:\名称, value: \name }
  { title:\LV, value: max_status \lv }
  { title:\HP, value: max_status \hp }
  { title:\攻擊力, value: max_status \at }
  { title:\防禦力, value: max_status \def }
  { title:\魔法耐性, value: max_status \regisit }
  { title:\射程, value: max_status \range }
  { title:\ブロック, value: max_status \block }
  { title:\コスト, value: max_status \max_cost }
]

activeDimensions = [
  \クラス
  \レア
]

PivotTable = React.createClass do
  render: ! ->
    return div {}

pivot-table-elem = React.createFactory PivotTable

module.exports = CharList = React.createClass do
  renderDimensions: ! ->
    selectedDimensions = @props.selected_dimensions

  render: ! ->
    console.log @props.chars.char_list
    return div {className: "mdl-grid"},
             div {className: "mdl-cell mdl-cell--12-col"},
               pivot-table-elem {
                 rows: @props.chars.char_list
                 dimensions: dimensions
                 calculations: calculations
                 reduce: reduce
                 activeDimensions:activeDimensions
               }

