
syntax keyword StartupAction Actions Files Folders Maps
syntax keyword StartupName   New File Manager Settings Projects Help Archives Old Quit
syntax keyword StartupPath   nvim init lua projetos programação config
syntax keyword StartupMaps   c n o f s p

syntax match StartupPoint   '•'

syntax match StartupSymbol  '\\'
syntax match StartupSymbol  '\/'
syntax match StartupSymbol  '\`'
syntax match StartupSymbol  '|'
syntax match StartupSymbol  '_'

syntax match StartupPath    '\.'
syntax match StartupPath    '\:'
syntax match StartupPath    '\~'

highlight default link StartupAction Keyword
highlight default link StartupName   Function
highlight default link StartupPoint  Number
highlight default link StartupSymbol Special
highlight default link StartupPath   Comment
highlight default link StartupMaps   Type
