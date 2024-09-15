local ts = {};

ts.inject = function (opts)
	if not opts or opts.enable == false then
		return;
	end

	for lang, conf in pairs(opts.languages) do
		if conf.enable == false then
			goto continue;
		end

		local _q = "";
		local _f = vim.treesitter.query.get_files(lang, "injections");

		for _, file in ipairs(_f) do
			local _r = io.open(file, "r");

			if _r then
				_q = _q .. _r:read("*all") .. "\n";
				_r:close();
			end
		end

		_q = _q .. conf.query;
		pcall(vim.treesitter.query.set, lang, _q);

		::continue::
	end
end

return ts;
