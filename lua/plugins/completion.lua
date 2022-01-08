-------------- Completion Configuration --------------

require('interface')

--  ﰩ   療﨡  כּ   φ

local settings = {
	['keymap'] = {
		['eval_snips'] = '',
		['jump_to_mark'] = '',
		['bigger_preview'] = '',
		['pre_select'] = false,
		['manual_complete'] = '<c-space>',
	},
	['display'] = {
		['ghost_text'] = {
			['enabled'] = false,
			['context'] = {' 〈 ', ' 〉'},
			['highlight_group'] = 'Comment'
		},
		['pum'] = {
			['x_max_len'] = 80,
			['y_max_len'] = 12,
			['y_ratio'] = 0.5,
			['ellipsis'] = '...',
			['kind_context'] = {' [', ']'},
			['source_context'] = {"「", "」"}
		},
		['preview'] = {
			['x_max_len'] = 80,
			['border'] = 'rounded',
			['positions'] = {
				['north'] = 1,
				['south'] = 2,
				['west'] = 3,
				['east'] = 4
			}
		},
		['icons'] = {
			['mode'] = "long",
			['spacing'] = 1,
			['aliases'] = {
				['EnumMember'] = 'Member',
				['TypeParameter'] = 'Type'
			},
			['mappings'] = {
				['Class'] = 'ﰩ',
				['Color'] = '',
				['Command'] = '',
				['Constant'] = 'π',
				['Constructor'] = '',
				['Enum'] = '',
				['EnumMember'] = '',
				['Event'] = 'כּ',
				['Field'] = '﨡',
				['File'] = ' File',
				['Folder'] = ' Folder',
				['Function'] = '',
				['Interface'] = '',
				['Keyword'] = '▢',
				['Method'] = '',
				['Module'] = '',
				['Operator'] = '◎',
				['Property'] = '',
				['Reference'] = '',
				['Snippet'] = '',
				['Struct'] = '',
				['Text'] = 'Aa Text',
				['TypeParameter'] = 'Ξ',
				['Unit'] = 'λ',
				['Value'] = 'β',
				['Variable'] = 'α'
			}
		}
	}
}

varglobal('coq_settings', settings)

function EnableCompletion()
	if get('filetype') == 'Startup' then
		return
	end

	execute(':COQnow --shut-up')
end

augroup('CompletionStart')
	autocmd()
	autocmd('BufEnter', '*', 'lua EnableCompletion()')
augroup('end')
