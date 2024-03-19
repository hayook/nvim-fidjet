local function createPopup(handlers)
	-- Create a new buffer for the popup content
	local bufnr = vim.api.nvim_create_buf(false, true)
	--
	-- Set modifiable option to false
	vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

	-- Get the dimensions of the entire Neovim editor
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")

	-- Window dimentions
	local winHeight = 7
	local winWidth = 40

	-- Calculate the centered position for the popup
	local row = (height / 2) - (winHeight * 0.639)
	local col = (width / 2) - (winWidth / 2)

	-- Define the options for the floating window
	local opts = {
		style = "minimal",
		relative = "editor",
		width = winWidth,
		height = winHeight,
		row = row,
		col = col,
		anchor = "NW", -- Anchor at the top-left corner
		focusable = false, -- Don't focus on the new window
		border = "single",
	}

	-- Create the floating window with the specified options
	local winid = vim.api.nvim_open_win(bufnr, true, opts)

	-- Close the popup when a key is pressed
	vim.api.nvim_buf_set_keymap(bufnr, "n", "c", ":q<CR>", { noremap = true, silent = true })

	-- choose a file to open
	vim.keymap.set("n", "<CR>", handlers.open_file_handler, { buffer = bufnr })

	-- delete a file (close it)
	vim.keymap.set("n", "d", handlers.close_file_handler, { buffer = bufnr })

	vim.api.nvim_buf_call(bufnr, function()
		vim.cmd([[set cursorline]])
	end)
	return { bufnr = bufnr, winid = winid }
end

local function render(lines, win)
	if lines.text == nil then lines.text = {} end
	if lines.danger == nil then lines.danger = {} end
	if lines.currentFileRef == nil then lines.currentFileRef = 0 end

	vim.api.nvim_buf_set_option(win.bufnr, "modifiable", true)

	-- Simulating align-self: flex-end
	local x = (" "):rep(36)

	-- Set the content of the popup buffer
	vim.api.nvim_buf_set_lines(win.bufnr, 0, -1, false, { x .. "(" .. #lines.danger .. ")" })
	vim.api.nvim_buf_set_lines(win.bufnr, 1, -1, false, lines.text)

	-- highlight modified lines
	for _, idx in ipairs(lines.danger) do
		vim.api.nvim_buf_add_highlight(win.bufnr, -1, "ErrorMsg", idx, 0, #(lines.text)[idx])
	end


	vim.api.nvim_win_set_cursor(win.winid, { lines.currentFileRef + 1, 0 })
	vim.api.nvim_buf_set_option(win.bufnr, "modifiable", false)
end

return {
	createPopup = createPopup,
	render = render
}
