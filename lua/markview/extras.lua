-- For testing purposes

local extras = {};

extras.show_headings = {
	headings = { " ", " ", " ", " ", " ", " " },
	headings_hl = { "MarkviewCol1Fg", "MarkviewCol2Fg", "MarkviewCol3Fg", "MarkviewCol4Fg", "MarkviewCol5Fg", "MarkviewCol6Fg" },

	__ns = vim.api.nvim_create_namespace("show_headings"),
	__buf = vim.api.nvim_create_buf(false, true),
	__win = nil,
	__timer = vim.uv.new_timer(),

	__prev_size = 0,
	__filtered_data = {},
	__max_title = 0,
	__on_heading = 1,

	create_ui = function (self)
		if not self.__win or not vim.api.nvim_win_is_valid(self.__win) then
			self.__win = vim.api.nvim_open_win(self.__buf, false, {
				relative = "win",

				row = 0,
				col = vim.api.nvim_win_get_width(self.attached_win) - (self.__max_title + 2),
				width = self.__max_title, height = #self.__filtered_data,

				title = " Headings ",
				focusable = false,
				border = "rounded"
			});
		else
			vim.api.nvim_win_set_config(self.__win, {
				relative = "win",

				row = 0,
				col = vim.api.nvim_win_get_width(self.attached_win) - (self.__max_title + 2),
				width = self.__max_title, height = #self.__filtered_data,
			});
		end

		vim.wo[self.__win].number = false;
		vim.wo[self.__win].relativenumber = false;

		vim.wo[self.__win].statuscolumn = "";
		vim.wo[self.__win].cursorline = false;

		vim.wo[self.__win].scrolloff = 0;

		vim.api.nvim_buf_set_lines(self.__buf, 0, -1, false, { "" });
		vim.api.nvim_buf_clear_namespace(self.__buf, self.__ns, 0, -1);

		for l, data in ipairs(self.__filtered_data) do
			vim.api.nvim_buf_set_lines(self.__buf, l - 1, l, false, { "" });

			vim.api.nvim_buf_set_extmark(self.__buf, self.__ns, l - 1, 0, {
				virt_text_pos = "overlay",
				virt_text = {
					{ string.rep("  ", data.level) },
					{ self.headings and self.headings[data.level] or "", (self.headings and self.headings_hl) and self.headings_hl[data.level] or nil },
					{ data.title }
				},

				hl_mode = "combine",
				line_hl_group = self.__on_heading == l and "CursorLine" or nil
			})
		end
	end,
	update_ui = function (self)
		vim.api.nvim_buf_clear_namespace(self.__buf, self.__ns, 0, -1);

		for l, data in ipairs(self.__filtered_data) do
			vim.api.nvim_buf_set_extmark(self.__buf, self.__ns, l - 1, 0, {
				virt_text_pos = "overlay",
				virt_text = {
					{ string.rep("  ", data.level) },
					{ self.headings and self.headings[data.level] or "", (self.headings and self.headings_hl) and self.headings_hl[data.level] or nil },
					{ data.title }
				},

				hl_mode = "combine",
				line_hl_group = self.__on_heading == l and "CursorLine" or nil
			})
		end
	end,

	filter = function (self)
		self.__filtered_data = {};

		for _, data in ipairs(_G.__markview_views[self.attached_buf]) do
			if data.type == "heading" then
				table.insert(self.__filtered_data, {
					title = data.title,
					level = data.level,

					start_line = data.row_start
				});

				local len = vim.fn.strlen(table.concat({
					string.rep("  ", data.level),
					self.headings and self.headings[data.level] or "",
					data.title,
					"  "
				}));

				if len > self.__max_title then
					self.__max_title = len
				end
			end
		end
	end,
	add_event_listener = function (self)
		self.cursor_listener = vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = self.attached_buf,
			callback = function ()
				local Y = vim.api.nvim_win_get_cursor(self.attached_win)[1];

				for l, v in ipairs(self.__filtered_data) do
					if Y >= v.start_line then
						self.__on_heading = l;
					end
				end

				self:update_ui();
			end
		})
		self.text_listener = vim.api.nvim_create_autocmd({ "ModeChanged", "TextChanged" }, {
			callback = function ()
				if vim.api.nvim_get_current_win() ~= self.attached_win then
					return;
				end

				self.__timer:stop()
				self.__timer:start(500, 0, vim.schedule_wrap(function ()
					if not self.cursor_listener and not self.text_listener then
						return;
					end

					local Y = vim.api.nvim_win_get_cursor(self.attached_win)[1];

					for l, v in ipairs(self.__filtered_data) do
						if Y >= v.start_line then
							self.__on_heading = l;
						end
					end

					self:filter();
					self:create_ui();
				end))
			end
		})
	end,

	init = function (self)
		if self.__win and vim.api.nvim_win_is_valid(self.__win) then
			return;
		end

		self.attached_buf = vim.api.nvim_get_current_buf();
		self.attached_win = vim.api.nvim_get_current_win();

		if not vim.api.nvim_buf_is_valid(self.attached_buf) or not _G.__markview_views then
			return;
		end

		if not _G.__markview_views[self.attached_buf] then
			return;
		end

		self:filter();

		local Y = vim.api.nvim_win_get_cursor(self.attached_win)[1];

		for l, v in ipairs(self.__filtered_data) do
			if Y >= v.start_line then
				self.__on_heading = l;
			end
		end

		self:create_ui();
		self:add_event_listener();
	end,
	kill = function (self)
		if self.__win then
			self.__win = vim.api.nvim_win_close(self.__win, true);
		end

		if self.cursor_listener then
			self.cursor_listener = vim.api.nvim_del_autocmd(self.cursor_listener)
		end

		if self.text_listener then
			self.text_listener = vim.api.nvim_del_autocmd(self.text_listener)
		end
	end,
	toggle = function (self)
		if self.__win then
			if not vim.api.nvim_win_is_valid(self.__win) then
				self.__win = nil;

				if self.cursor_listener then
					self.cursor_listener = vim.api.nvim_del_autocmd(self.cursor_listener)
				end

				if self.text_listener then
					self.text_listener = vim.api.nvim_del_autocmd(self.text_listener)
				end

				self:init();
			else
				self:kill();
			end
		else
			self:init();
		end
	end
}

extras.code_block_editor = {
	__buf = vim.api.nvim_create_buf(false, true),
	__win = nil,

	__width = 60,
	__padding = 2 + 2,

	__pos = { 1, 0 },

	__prefix = "",

	check_for_available_spaces = function (self, data)
		local win_height = vim.api.nvim_win_get_height(self.attached_win);
		local screen_row = vim.fn.winline();

		local block_size = data.row_end - data.row_start;

		local visible_start = self.__pos[1] - screen_row;
		local visible_end = visible_start + win_height;

		if block_size > win_height then
			return false;
		elseif data.row_start < visible_start or data.row_end > visible_end then
			return false;
		end

		return true;
	end,

	fix_lines = function (self, lines, amount)
		local _o = {};

		for i, line in ipairs(lines) do
			if i == 1 then
				self.__prefix = vim.fn.strcharpart(line, 0, amount);
			end

			table.insert(_o, vim.fn.strcharpart(line, amount));
		end

		return _o;
	end,
	fix_outputs = function (self, lines)
		local _o = {};

		for _, line in ipairs(lines) do
			-- FIX: Whitespaces are replaced with normal spaces
			line = line:gsub("^(%s*)", string.rep(" ", vim.fn.strdisplaywidth(line:match("^(%s*)"))));
			table.insert(_o, self.__prefix .. line);
		end

		return _o;
	end,
	open_float = function (self, data)
		local extmaks_before = vim.api.nvim_buf_get_extmarks(self.attached_buf, -1, { data.row_start, data.col_start }, { data.row_start, 0 }, { type = "virt_text", details = true });

		self.__win = vim.api.nvim_open_win(self.__buf, true, {
			relative = "win",
			row = 0, col = #extmaks_before * -1,
			bufpos = { data.row_start, data.col_start },
			width = self.__width + self.__padding, height = (data.row_end - data.row_start) - 2,

			border = "rounded",
			title = " " .. (data.language or "") .. " ",
			title_pos = "right"
		})

		if data.col_start > 0 then
			local lines = self:fix_lines(data.lines, data.col_start);

			vim.api.nvim_buf_set_lines(self.__buf, 0, -1, false, lines);
		else
			vim.api.nvim_buf_set_lines(self.__buf, 0, -1, false, data.lines);
		end

		vim.bo[self.__buf].filetype = data.language;
		vim.wo[self.__win].number = false;
		vim.wo[self.__win].relativenumber = false;
		vim.wo[self.__win].statuscolumn = "  ";
		vim.wo[self.__win].cursorline = false;

		if self.__pos[1] > (data.row_start + 1) and self.__pos[1] < (data.row_end - 1) then
			vim.api.nvim_win_set_cursor(self.__win, { self.__pos[1] - data.row_start - 1, self.__pos[2] })
		end
	end,
	set_features = function (self, data)
		vim.api.nvim_buf_set_keymap(self.__buf, "n", "<CR>", "", {
			callback = function ()
				self:write(data);
			end
		});

		vim.api.nvim_buf_set_keymap(self.__buf, "n", "q", "", {
			callback = function ()
				vim.api.nvim_win_close(self.__win, true);
			end
		});

		if self.__set_autocmd then
			return
		end

		self.__set_autocmd = true;

		vim.api.nvim_create_autocmd({ "BufLeave" }, {
			buffer = self.__buf,
			callback = function ()
				vim.api.nvim_win_close(self.__win, true);
			end
		})
	end,

	init = function (self)
		if self.__win and vim.api.nvim_win_is_valid(self.__win) then
			return;
		end

		self.attached_buf = vim.api.nvim_get_current_buf();
		self.attached_win = vim.api.nvim_get_current_win();

		self.__pos = vim.api.nvim_win_get_cursor(self.attached_win);

		if not vim.api.nvim_buf_is_valid(self.attached_buf) or not _G.__markview_views then
			return;
		end

		if not _G.__markview_views[self.attached_buf] then
			return;
		end

		for _, data in ipairs(_G.__markview_views[self.attached_buf]) do
			if data.type == "code_block" and (self.__pos[1] >= data.row_start and self.__pos[1] <= data.row_end and self.__pos[2] >= data.col_start) then
				if not self:check_for_available_spaces(data) then
					vim.print("Not enough lines available! Aborting.");
					break;
				elseif (data.row_end - data.row_start) - 2 <= 0 then
					vim.print("Code block is too small! Aborting.")
					break;
				end

				self:open_float(data);
				self:set_features(data);
				break;
			end
		end
	end,
	write = function (self, data)
		local _out = self:fix_outputs(vim.api.nvim_buf_get_lines(self.__buf, 0, -1, false))

		if data.col_start > 0 then
			vim.api.nvim_buf_set_lines(self.attached_buf, data.row_start + 1, data.row_end - 1, false, _out)
		else
			vim.api.nvim_buf_set_lines(self.attached_buf, data.row_start + 1, data.row_end - 1, false, _out);
		end

		vim.api.nvim_win_close(self.__win, true);
	end
}

return extras;
