--Shows curently opened buffers in Telescope

local function picker(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local make_entry = require("telescope.make_entry")

	local function isBuffValid(n)
		return vim.api.nvim_buf_is_valid(n) and vim.bo[n].buflisted
	end

	opts = opts or {}

	local bufnrs = vim.tbl_filter(isBuffValid, vim.t.bufs)

	if not next(bufnrs) then
		return
	end

	local buffers = {}
	local default_selection_idx = 1
	for _, bufnr in ipairs(bufnrs) do
		local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

		local element = {
			bufnr = bufnr,
			flag = flag,
			info = vim.fn.getbufinfo(bufnr)[1],
		}

		table.insert(buffers, element)
	end

	local max_bufnr = math.max(unpack(bufnrs))
	opts.bufnr_width = #tostring(max_bufnr)

	pickers
		.new(opts, {
			prompt_title = "Buffers",
			finder = finders.new_table({
				results = buffers,
				entry_maker = make_entry.gen_from_buffer(opts),
			}),
			previewer = conf.grep_previewer(opts),
			sorter = conf.generic_sorter(opts),
			default_selection_index = default_selection_idx,
		})
		:find()
end

return {
	buffer_picker = picker,
}
