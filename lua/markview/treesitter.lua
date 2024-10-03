local ts = {};

--- Fixes indentation of the provided text
---
--- ```query
---		(section
---			(atx_heading)) @fold
---			(#set! @fold)
--- ```
--- 
--- Will become,
---
--- ```query
--- (section
---		(atx_heading)) @fold
---		(#set! @fold)
--- ```
---@param text string
---@return string
local fix_indent = function (text)
	local _l = "";
	local leading_spaces;

	if text:sub(-1) ~= "\n" then text = text .. "\n" end

	for line in text:gmatch("(.-)\n") do
		if not leading_spaces then
			leading_spaces = line:match("^%s+");
		end

		line = line:gsub("^" .. leading_spaces, "");
		_l = _l .. line .. "\n";
	end

	_l = _l:gsub("(\n)$", "");

	return _l;
end

---@param opts markview.conf.injections
ts.inject = function (opts)
	if not opts or opts.enable == false or not vim.islist(opts.languages) then
		return;
	end

	--- Iterate over all the languages
	for lang, conf in pairs(opts.languages) do
		if conf.enable == false then
			goto continue;
		end

		local _q = "";

		if conf.overwrite == true then
			goto skip;
		end

		--- Get the default injections file
		local _f = vim.treesitter.query.get_files(lang, "injections");

		for _, file in ipairs(_f) do
			local _r = io.open(file, "r");

			--- Read all the contents from the file and close it
			--- If nil, then no injections exist for this language
			if _r then
				_q = _q .. _r:read("*all") .. "\n";
				_r:close();
			end
		end

		::skip::

		--- Append the new query
		--- TODO, Fix indentation
		_q = _q .. fix_indent(conf.query);
		pcall(vim.treesitter.query.set, lang, _q);

		::continue::
	end
end

return ts;
