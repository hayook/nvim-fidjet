local function extractFileName(filePath)
	local fileName = string.match(filePath, "[\\/]([^\\/]*)$") -- Match the last part after the last backslash or forward slash
	if fileName == nil then
		return filePath
	end
	return fileName
end

local function getFileIdx(fileId, files)
	for idx, file in ipairs(files) do
		if fileId == file.fileId then return idx end
	end
	return nil
end

local function produceLines(files)
	local text = {}
	local danger = {}
	for count, file in ipairs(files.list) do
		-- (Beta) - local changedSymbol = file.changed and "[+]" or "   "
		local line = file.fileRef .. ". " .. extractFileName(file.relativePath)
		table.insert(text, line)
		if file.changed then table.insert(danger, count) end
	end
	return { text = text, danger = danger, currentFileRef = files.currentFileRef }
end

return {
	extractFileName = extractFileName,
	getFileIdx = getFileIdx,
	produceLines = produceLines,
}
