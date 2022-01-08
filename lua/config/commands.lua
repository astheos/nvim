--------------- General Commands ----------------

require('interface')

-- Change Mode

command('Visual', 'normal! v')

command('Insert', 'normal! i')
command('Append', 'normal! a')

command('Replace', 'normal! R')

-- Open Help

cabbrev('help', 'vertical help')
