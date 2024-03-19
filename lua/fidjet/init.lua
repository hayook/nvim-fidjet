local function displayOpenFiles()
	local files = GetOpenFiles()
	local lines = ProduceLines(files)
	local current_winid = vim.fn.win_getid(vim.fn.winnr())
	local win
	local handlers = {}

	local function open_file_handler()
		local fileRef = vim.fn.line(".") - 1
		if fileRef < 1 then return end
		vim.api.nvim_command(":q")
		vim.api.nvim_set_current_buf(files.list[fileRef].fileId)
	end

	local function close_file_handler()
		local fileRef = vim.fn.line(".") - 1
		if fileRef < 1 then return end
		local targetFileId = files.list[fileRef].fileId
		local altFileId = GetAlternativeFile(files, targetFileId)
		vim.api.nvim_win_set_buf(current_winid, altFileId)
		local res = DeleteFile(files, targetFileId)
		files = GetOpenFiles()
		if #files.list == 0 then
			vim.api.nvim_command(":q")
			return
		end

		files.currentFileRef = GetFileIdx(altFileId, files.list)
		lines = ProduceLines(files)
		Render(lines, win)
	end

	handlers.open_file_handler = open_file_handler
	handlers.close_file_handler = close_file_handler

	win = CreatePopup(handlers)
	Render(lines, win)
end

local function closeCurrentFile()
	local files = GetOpenFiles()
	if files.currentFileRef == nil then
		vim.api.nvim_err_writeln("[HAYOO] No open files to close.")
		return
	end
	local altFileId = GetAlternativeFile(files, files.list[files.currentFileRef].fileId)
	local currentFileId = files.list[files.currentFileRef].fileId
	if not files.list[files.currentFileRef].changed then vim.api.nvim_command(":b " .. altFileId) end
	DeleteFile(files, currentFileId)
end

return {
	displayOpenFiles = displayOpenFiles,
	closeCurrentFile = closeCurrentFile,
}
