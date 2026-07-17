-- sinonims.nvim
--
-- Un connector de Neovim per a consultar el Diccionari de sinònims d'Albert Jané
--
-- Author: Llibert Manent Oristrell
-- Year: 2026

local M = {}

local titol = "Diccionari de sinònims d'Albert Jané"

local config = {
	width = 60,
	height = 10,
	format_titol = "@markup.heading", -- (hl_group)
	format_terme = "Title",          -- (hl_group)
	format_categoria = "Comment",    -- (hl_group)
}

local function centrar(line)
	local space = config.width - vim.fn.strdisplaywidth(line)
	local l = math.floor(space / 2)
	local r = space - l

	return string.rep(" ", l) .. line .. string.rep(" ", r)
end

local function renderitzar(buf, ns, lines, highlights)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	for _, hl in ipairs(highlights) do
		vim.api.nvim_buf_set_extmark(buf, ns, hl.row, hl.start_col, {
			end_col = hl.end_col,
			hl_group = hl.hl_group,
		})
	end
end

local function formatar_tags(line, row, highlights)
	local marcador = "#"

	while true do
		local inici, final = line:find(marcador .. "[^%s%p‘’]+")

		if not inici then
			break
		end

		line = line:gsub(marcador, "")

		table.insert(highlights, {
			row = row,
			start_col = vim.str_utfindex(line, "utf-8", inici),
			end_col = vim.str_utfindex(line, "utf-8", final) - vim.str_utfindex(marcador, "utf-8") + 1,
			hl_group = "italic",
		})
	end

	return line
end

local function consultar(terme)
	local path = vim.api.nvim_get_runtime_file("lua/sinonims/sinonims.txt", false)[1]
	local file = io.open(path, "r")

	if not file then
		print("No s'ha pogut obrir el diccionari de sinònims")
		return
	end

	local found = false
	local linies = { centrar(titol) }
	local highlights = {}
	local row = 1

	table.insert(highlights, {
		row = 0,
		start_col = 1,
		end_col = config.width + 1,
		hl_group = config.format_titol,
	})

	for line in file:lines() do
		if line:match("^\\") and found then
			break
		end

		if line:match("^" .. terme) or line:match(" | " .. terme) then
			found = true
		end

		if found then
			if line:match("^" .. terme) or line:match(" | " .. terme) then
				local paraula, tipus = line:match("^(.-) #(.*)$")

				tipus = tipus:gsub("#", "")
				tipus = tipus:gsub("\\", "")

				local fi_paraula = vim.str_utfindex(paraula, "utf-8")

				table.insert(linies, " ")
				row = row + 1

				table.insert(linies, paraula .. " " .. tipus)

				vim.list_extend(highlights, {
					{
						row = row,
						start_col = 0,
						end_col = fi_paraula,
						hl_group = config.format_terme,
					},
					{
						row = row,
						start_col = fi_paraula + 1,
						end_col = vim.str_utfindex(tipus, "utf-8") + fi_paraula + 1,
						hl_group = config.format_categoria,
					},
				})

				if not line:match("\\") then
					table.insert(linies, " ")
					row = row + 1
				end
			elseif line:match("^ [(]") then
				table.insert(linies, " " .. formatar_tags(line, row, highlights))

				table.insert(linies, " ")

				row = row + 1
			else
				table.insert(linies, " " .. line)
			end

			row = row + 1
		end
	end

	file:close()

	if not found then
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)

	local sinonims = vim.api.nvim_create_namespace("sinonims")

	renderitzar(buf, sinonims, linies, highlights)

	local opts = {
		relative = "editor",
		width = config.width,
		height = config.height,
		row = math.floor((vim.o.lines - config.height) / 2),
		col = math.floor((vim.o.columns - config.width) / 2),
		style = "minimal",
		border = "rounded",
	}

	vim.api.nvim_open_win(buf, true, opts)
end

function M.lookup_word()
	local terme = vim.fn.expand("<cword>")

	if terme == "" then
		return
	end

	consultar(terme)
end

function M.lookup_selection()
	local terme = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")))

	if terme == "" then
		return
	end

	consultar(terme)
end

function M.setup()
	vim.api.nvim_create_user_command("Sinonim", function()
		M.lookup_word()
	end, {})

	vim.keymap.set("n", "gs", M.lookup_word, {
		desc = "Consultar sinònims sobre el cursor",
	})

	vim.keymap.set("v", "gs", M.lookup_selection, {
		desc = "Consultar sinònims",
	})
end

return M
