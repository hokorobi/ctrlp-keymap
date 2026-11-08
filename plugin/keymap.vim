vim9script

if exists('g:loaded_ctrlp_keymap_plugin')
  finish
endif
g:loaded_ctrlp_keymap_plugin = 1

command! CtrlPKeymap ctrlp#init(ctrlp#keymap#Id())
