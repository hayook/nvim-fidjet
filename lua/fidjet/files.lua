local function getOpenFiles()
	local files = {}
	local open_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	for idx, buf in ipairs(open_bufs) do
		local file = {
			fileId = buf.bufnr,
			relativePath = vim.fn.bufname(buf.bufnr),
			changed = buf.changed == 1,
			fileRef = idx,
			current = true
		}
		table.insert(files, file)
	end
	local currentFileId = vim.fn.bufnr('%')
	local currentFileRef = GetFileIdx(currentFileId, files)
	return { list = files, currentFileRef = currentFileRef }
end

function GetAlternativeFile(files, fileId)
	if #files.list == 0 then return -1 end
	local targetFileRef = GetFileIdx(fileId, files.list)
	if targetFileRef == nil then return #files.list[1] end
	local prev_ref = targetFileRef - 1
	if prev_ref == 0 then prev_ref = #files.list end
	return files.list[prev_ref].fileId
end

local function deleteFile(files, fileId)
	local targetFileRef = GetFileIdx(fileId, files.list)
	if targetFileRef == nil then
		vim.api.nvim_err_writeln("[HAYOO] Fiel doesn't exist.")
		return -1
	end
	local targetFile = files.list[targetFileRef]
	if targetFile.changed then
		vim.api.nvim_err_writeln("[HAYOO] Save to quit.")
		return -1
	end
	vim.api.nvim_command('bdelete ' .. fileId)
	return 1
end

return {
	getOpenFiles = getOpenFiles,
	deleteFile = deleteFile,
}
