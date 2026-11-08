vim9script

if exists('g:loaded_ctrlp_keymap') && g:loaded_ctrlp_keymap
  finish
endif
g:loaded_ctrlp_keymap = 1

g:ctrlp_ext_vars = get(g:, 'ctrlp_ext_vars', []) -> add({
  init: 'ctrlp#keymap#Init()',
  accept: 'ctrlp#keymap#Accept',
  lname: 'keymap',
  sname: 'kmap',
  type: 'line',
  sort: 0,
})

const IndexId = ctrlp#getvar('g:ctrlp_builtins') + len(g:ctrlp_ext_vars)
export def Id(): number
  return IndexId
enddef

var keymaps: list<dict<any>> = []
export def Init(): list<string>
  keymaps = []
  var raw_maps = maplist()
  var lines: list<string> = []

  for m in raw_maps
    var mode = get(m, 'mode', '')
    var lhs = get(m, 'lhs', '')
    var rhs = get(m, 'rhs', '')
    var noremap = get(m, 'noremap', 0) ? '*' : ' '
    var buffer = get(m, 'buffer', 0) ? '@' : ' '
    var attr = noremap .. buffer

    var padding = ' '
    var mode_str = mode .. repeat(' ', max([0, 2 - len(mode)])) .. padding
    var lhs_str = lhs .. repeat(' ', max([0, 11 - len(lhs)])) .. padding
    var attr_str = attr .. repeat(' ', max([0, 2 - len(attr)]))

    var line = mode_str .. lhs_str .. attr_str .. rhs

    add(keymaps, { map: m, line: line })
    add(lines, line)
  endfor

  return lines
enddef

export def Accept(mode: string, str: string)
  var selected: dict<any> = {}
  for item in keymaps
    if item.line ==# str
      selected = item.map
      break
    endif
  endfor

  if empty(selected)
    return
  endif

  ctrlp#exit()

  var lhs = get(selected, 'lhs', '')
  if !empty(lhs)
    execute $'verbose {get(selected, 'mode', '')}map {lhs}'
  endif
enddef