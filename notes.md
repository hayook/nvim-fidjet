
Interface File {
	fileId: number
	relativePath: string,
	changed: boolean,
}

GetOpenFiles(void): File[]

Interface Line {
	text: string[],
	danger: number[],
}
ProduceLines(files: File[]): Line[]

Interface Win {
    winid: number,
    bufnr: number,
}

CreatePopup(handlers: Function[]): Win

Render(lines: Line[], win: Win)

GetAlternativeFile(files: File[]): number {
    if the files list is empty return -1
    if there is no current file return the first file in the list
    get the reference before the reference of the current file
    if the reference is 0, set it to be the length of the files list
    return the id of the file in that reference
}

DeleteFile(files: File[], fileId: number): number|nil {
    get the reference of the file
    if the file doesn't exist, print an eror and return -1
    get the file
    if the file got modified, print an error and return -1
    delete the file
}

CloseCurrentFile(void): void {
    get the files list
    if the there is no current file, print an error and return
    call GetAlternativeFile using the files
    if the result is -1 return
    get the id of the alternative file
    set it to be the next
    get the id of the current file
    call Deletefile with the files and the current file id
}

## Future Features
* add reactivity
    * press "p" to change between absolute/relative path and file name
    * press "l/h" to split the window to the right/left
    * switch the order of the files
* find a solution for the last buffer (it's jsut annoying)
* add the quick list to switch between only two

