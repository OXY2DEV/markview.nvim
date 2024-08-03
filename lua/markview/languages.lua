local languages = {};

languages.patterns = {
	{ ".*%.feature", "Cucumber" },

	{ ".*%.abap", "Abap" },

	{ ".*%.ada", "Ada" },
	{ "adb", "Ada" },
	{ "ads$", "Ada" },

	{ "htaccess", "Apacheconf" },
	{ "apache.conf", "Apacheconf" },
	{ "apache2.conf", "Apacheconf" },

	{ ".*%.as", "As" },
	{ ".%*%.asy", "Asy" },

	{ "ahkl", "Ahk" },

	{ "sh", "Bash" },
	{ "ksh", "Bash" },
	{ "ksh", "Bash" },
	{ ".*%.ebuild", "Bash" },
	{ ".*%.eclass", "Bash" },

	{ ".*%.befunge", "Befunge" },
	{ ".*%.bmx", "Blitzmax" },
	{ ".*%.boo", "Boo" },

	{ "bf", "Brainfuck" },
	{ "b", "Brainfuck" },

	{ "cmd", "Bat" },

	{ ".*%.cfc", "Cfm" },
	{ "cfml", "Cfm" },

	{ "cl", "Cl" },
	{ "lisp", "Cl" },
	{ ".*%.el", "Cl" },

	{ "clj", "Clojure" },
	{ "cljs", "Clojure" },

	{ "h", "C" },
	{ "c", "C" },
	{ ".*.cmake", "Cmake" },

	{ "coffee", "Cofeescript" },
	{ ".*%.sh%-session", "Console" },

	{ "cpp", "C++" },
	{ "hpp", "C++" },
	{ "cc", "C++" },
	{ "hh", "C++" },
	{ "cxx", "C++" },
	{ "hxx", "C++" },
	{ ".*%.pde", "C++" },

	{ "csharp", "C#" },
	{ "cs", "C#" },
	{ ".*.%cs", "C#" },

	{ "css", "CSS" },

	{ "pyx", "Cython" },
	{ "pxd", "Cython" },
	{ ".*%.pxi", "Cython" },

	{ "d", "D" },
	{ "di", "D" },

	{ ".*%.pas", "Delphi" },

	{ "patch", "Diff" },

	{ "darcspatch", "Dpatch" },

	{ "jbst", "Duel" },

	{ "dyl", "Dylan" },

	{ ".*%.erb", "Erb" },

	{ ".*%.erl%-sh", "Erl" },

	{ "erl", "Erlang" },
	{ "hrl", "Erlang" },

	{ "flx", "Felix" },
	{ "flxh", "Felix" },

	{ "f", "Fortran" },
	{ "f90", "Fortran" },

	{ "s", "Gas" },
	{ "S", "Gas" },

	{ ".*%.kid", "Genshi" },

	{ "gitignore", "Gitignore" },

	{ "vert", "GLSL" },
	{ "frag", "GLSL" },
	{ ".*%.geo", "GLSL" },

	{ "plot", "Gnuplot" },
	{ "plt", "Gnuplot" },

	{ ".*%.go", "Go" },

	{ "hs", "Haskell" },
	{ ".*%.hs", "Haskell" },

	{ "htm", "Html" },
	{ "xhtml", "Html" },
	{ "xslt", "Html" },

	{ ".*%.hx", "Hx" },

	{ "hy", "Hybris" },
	{ "hyb", "Hybris" },

	{ "ini", "INI" },
	{ "cfg", "INI" },

	{ ".*%.io", "Io" },
	{ "ik", "Ioke" },

	{ ".*%.jade", "Jade" },

	{ ".*%.Java", "Java" },

	{ "ll", "LLVM" },

	{ "wlua", "Lua" },

	{ "mak", "Make" },
	{ "makefile", "Make" },
	{ "Makefile", "Make" },
	{ "GNUmakefile", "Make" },

	{ ".*%.mao", "Make" },

	{ "mhtml", "Mason" },
	{ "mc", "Mason" },
	{ ".*%.mi", "Mason" },
	{ "autohandler", "Mason" },
	{ "dhandler", "Mason" },

	{ "md", "Markdown" },

	{ "m", "Objective C" },
	{ ".*%.m", "Objective C" },
	{ ".*%.j", "Objective J" },

	{ "ml", "Ocaml" },
	{ "mli", "Ocaml" },
	{ "mll", "Ocaml" },
	{ "mly", "Ocaml" },

	{ "pm", "Perl" },
	{ "pl", "Perl" },

	{ "php", "PHP" },

	{ "ps", "Postscript" },
	{ "eps", "Postscript" },

	{ "pro", "Prolog" },
	{ ".*%.pl", "Prolog" },

	{ ".*%.properties", "Properties" },

	{ ".*%.py3tb", "Py3tb" },
	{ ".*%.pytb", "Pytb" },
	{ "py", "Python" },
	{ "pyw", "Python" },
	{ "sc", "Python" },
	{ "SConstruct", "Python" },
	{ "SConscript", "Python" },
	{ "tac", "Python" },

	{ ".*%.R", "R" },

	{ "rb", "Ruby" },
	{ "rbw", "Ruby" },
	{ "RakeFile", "Ruby" },
	{ "rake", "Ruby" },
	{ "gemspec", "Ruby" },
	{ "rbx", "Ruby" },
	{ "duby", "Ruby" },

	{ "rs", "rust" },

	{ "sql", "SQL" },
	{ ".*%.sql", "SQL" },

	{ "txt", "Text" },

	{ "ts", "Typescript" },

	{ "yml", "Yaml" },
};

languages.get_name = function (name)
	if not name or name == "" then
		return "Unknown";
	end

	for _, pattern in ipairs(languages.patterns) do
		if name:match("^" .. pattern[1] .. "$") then
			return pattern[2];
		end
	end

	return string.gsub(name, "^%l", string.upper);
end

return languages;
