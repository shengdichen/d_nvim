local m_luasnip = require("luasnip")
local snippet = m_luasnip.snippet

local function make_nodes()
    local nodes = {
        text = m_luasnip.text_node,
        insert = m_luasnip.insert_node,
        choice = m_luasnip.choice_node,
        raw = m_luasnip.snippet_node,
        func = m_luasnip.function_node,
        dynamic = m_luasnip.dynamic_node,
        restore = m_luasnip.restore_node,
        indent = m_luasnip.indent_snippet_node
    }

    nodes.choice_raw = function(ns)
        -- NOTE:
        --  call-site must guarantee at least one stoppable node in the passed-in args
        return nodes.raw(nil, ns)
    end
    nodes.choice_text = function(txt, stop_before)
        -- NOTE:
        --  must couple a pure-text choice-node with an insert-node to allow stopping at it
        -- REF:
        --  https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#choicenode
        --  https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippetnode

        local t = nodes.text(txt)
        if stop_before then return nodes.choice_raw({ nodes.insert(1), t }) end
        return nodes.choice_raw({ t, nodes.insert(1) })
    end
    nodes.choice_insert = function(txt)
        return nodes.insert(nil, txt)
    end
    nodes.choice_blank = function()
        return nodes.choice_insert()
    end

    nodes.linebreak = function(count)
        local text = {}
        for _ = 0, count or 1 do
            table.insert(text, "")
        end
        return nodes.text(text)
    end
    nodes.tab = function(count)
        local text = string.rep(" ", 4 * (count or 1))
        return nodes.text(text)
    end
    nodes.break_formatted = function(idx)
        nodes.indent(
            idx,
            { nodes.text({ "", "" }) },
            ""
        )
    end

    return nodes
end
local nodes = make_nodes()

local function shell()
    local snippets = {
        snippet("scriptpath", {
            nodes.text('SCRIPT_PATH="$(realpath "$(dirname "${0}")")"'),
            nodes.linebreak(),
        }),
        snippet("scriptname", {
            nodes.text('SCRIPT_NAME="$(basename "${0}")"'),
            nodes.linebreak(),
        }),
        snippet("stowname", {
            nodes.choice(1, {
                {
                    nodes.text('STOW_NAME="$(basename "${SCRIPT_PATH}")"'),
                    nodes.linebreak(2),
                    nodes.insert(1),
                },
                nodes.choice_text('"$(basename "${SCRIPT_PATH}")"'),
                nodes.choice_text('$(basename "${SCRIPT_PATH}")'),
            }),
        }),

        snippet("var", {
            nodes.choice(1, {
                { nodes.text('"${'), nodes.insert(1, "var?"), nodes.text('}"'), },
                { nodes.text("${"),  nodes.insert(1, "var?"), nodes.text("}"), },
            })
        }),
        snippet("v#", {
            nodes.choice(1, {
                nodes.choice_text('"${#}"'),
                nodes.choice_text("${#}"),
            })
        }),
        snippet("v1", {
            nodes.choice(1, {
                nodes.choice_text('"${1}"'),
                nodes.choice_text("${1}"),
            })
        }),
        snippet("v2", {
            nodes.choice(1, {
                nodes.choice_text('"${2}"'),
                nodes.choice_text("${2}"),
            })
        }),
        snippet("v3", {
            nodes.choice(1, {
                nodes.choice_text('"${3}"'),
                nodes.choice_text("${3}"),
            })
        }),
        snippet("v@", {
            nodes.choice(1, {
                nodes.choice_text('"${@}"'),
                nodes.choice_text("${@}"),
            })
        }),
        snippet("v*", {
            nodes.choice(1, {
                nodes.choice_text('"${*}"'),
                nodes.choice_text("${*}"),
            })
        }),

        snippet("fn", {
            nodes.insert(1, "fn?"), nodes.text("() {"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(),
            nodes.text("}"),
            nodes.linebreak(),
        }),
        snippet("fnret", {
            nodes.choice(1, {
                { nodes.text('"$('), nodes.insert(1, "var?"), nodes.text(')"'), },
                { nodes.text("$("),  nodes.insert(1, "var?"), nodes.text(")"), },
            })
        }),
        snippet("sub", {
            nodes.text("("),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(1, "what?"),
            nodes.linebreak(),
            nodes.text(")"),
            nodes.linebreak(),
        }),
        snippet("cd", {
            nodes.choice(1, {
                {
                    nodes.text("cd "),
                    nodes.insert(1, "where?"),
                    nodes.text(" || exit "),
                    nodes.insert(2, "3"),
                    nodes.linebreak(),
                },
                {
                    nodes.text("cd "),
                    nodes.insert(1, "where?"),
                    nodes.text(" && "),
                    nodes.insert(2, "what?"),
                },
            })
        }),

        --  if $1; then
        --      $0
        --  fi
        snippet("if", {
            nodes.text("if "), nodes.insert(1, "test?"), nodes.text("; then"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(),
            nodes.text("fi"),
            nodes.linebreak()
        }),
        snippet("if--", {
            nodes.text('if [ "${1}" = "--" ]; then shift; fi')
        }),

        snippet("tt", {
            nodes.text("[ "),
            nodes.insert(1, "test?"),
            nodes.text(" ]")
        }),
        -- test: os
        snippet("te", {
            nodes.choice(1, {
                { nodes.text("[ -e "),   nodes.insert(1, "path?"), nodes.text(" ]"), },
                { nodes.text("[ ! -e "), nodes.insert(1, "path?"), nodes.text(" ]"), },
            })
        }),
        snippet("tf", {
            nodes.choice(1, {
                { nodes.text("[ -f "),   nodes.insert(1, "path?"), nodes.text(" ]"), },
                { nodes.text("[ ! -f "), nodes.insert(1, "path?"), nodes.text(" ]"), },
            })
        }),
        snippet("td", {
            nodes.choice(1, {
                { nodes.text("[ -d "),   nodes.insert(1, "path?"), nodes.text(" ]"), },
                { nodes.text("[ ! -d "), nodes.insert(1, "path?"), nodes.text(" ]"), },
            })
        }),
        --  test: string
        snippet("tstr", {
            nodes.choice(1, {
                { nodes.text("[ "),   nodes.insert(1, "str?"), nodes.text(" ]"), },
                { nodes.text("[ ! "), nodes.insert(1, "str?"), nodes.text(" ]"), },
            })
        }),
        snippet("tstrtrue", {
            nodes.text("[ -n "), nodes.insert(1, "str?"), nodes.text(" ]")
        }),
        snippet("tstrfalse", {
            nodes.text("[ -z "), nodes.insert(1, "str?"), nodes.text(" ]")
        }),
        snippet("tstr==", {
            nodes.text("[ "),
            nodes.insert(1, "str?"),
            nodes.text(" = "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        snippet("tstr!=", {
            nodes.text("[ "),
            nodes.insert(1, "str?"),
            nodes.text(" != "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        -- test: algebraic
        snippet("t==", {
            nodes.text("[ "),
            nodes.insert(1, "var?"),
            nodes.text(" -eq "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        snippet("t!=", {
            nodes.text("[ "),
            nodes.insert(1, "var?"),
            nodes.text(" -ne "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        snippet("t>", {
            nodes.text("[ "),
            nodes.insert(1, "var?"),
            nodes.text(" -gt "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        snippet("t>=", {
            nodes.text("[ "),
            nodes.insert(1, "var?"),
            nodes.text(" -ge "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        snippet("t<", {
            nodes.text("[ "),
            nodes.insert(1, "var?"),
            nodes.text(" -lt "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),
        snippet("t<=", {
            nodes.text("[ "),
            nodes.insert(1, "var?"),
            nodes.text(" -le "),
            nodes.insert(2, "value"),
            nodes.text(" ]"),
        }),

        -- REF:
        --  https://www.shellcheck.net/wiki/SC2044
        snippet("forfind", {
            nodes.text("find "), nodes.insert(1, "where?"),
            nodes.text(" -maxdepth "), nodes.insert(2, "depth?"),
            nodes.text(" -type "), nodes.insert(3, "type?"),
            nodes.text(' ! -name "$(printf "*\\n*")"'),
            nodes.text(" |"),
            nodes.linebreak(),

            nodes.tab(), nodes.text('while IFS="" read -r _path; do'), nodes.linebreak(),
            nodes.tab(2), nodes.text('printf "> [%s]\\n" "${_path}"'), nodes.linebreak(),
            nodes.tab(2), nodes.insert(4, "what?"), nodes.linebreak(),
            nodes.tab(), nodes.text("done"), nodes.linebreak(),

            nodes.insert(0)
        }),
        snippet("forfindtmp", {
            nodes.text('local _tmp="./_tmp"'), nodes.linebreak(),
            nodes.text('mkdir "${_tmp}"'), nodes.linebreak(),

            nodes.text("find "), nodes.insert(1, "where?"),
            nodes.text(" -maxdepth "), nodes.insert(2, "depth?"),
            nodes.text(" -type "), nodes.insert(3, "type?"),
            nodes.text(' ! -name "$(printf "*\\n*")"'),
            nodes.text(' >"${_tmp}"'),
            nodes.linebreak(),

            nodes.text('while IFS="" read -r _path; do'), nodes.linebreak(),
            nodes.tab(), nodes.text('printf "> [%s]\\n" "${_path}"'), nodes.linebreak(),
            nodes.tab(), nodes.insert(4, "what?"), nodes.linebreak(),
            nodes.text('done <"${_tmp}"'), nodes.linebreak(),

            nodes.text('rm "${_tmp}"'), nodes.linebreak(),
            nodes.insert(0)
        }),

        snippet("while", {
            nodes.text("while "), nodes.insert(1, "test?"), nodes.text("; do"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(),
            nodes.text("done"),
            nodes.linebreak(),
            nodes.insert(0)
        }),
        snippet("case", {
            nodes.text("case "), nodes.insert(1, "var?"), nodes.text(" in"),
            nodes.linebreak(),

            nodes.tab(), nodes.text('"'), nodes.insert(2, "val1?"), nodes.text('")'),
            nodes.linebreak(),
            nodes.tab(2), nodes.insert(3, "what?"),
            nodes.linebreak(),
            nodes.tab(2), nodes.text(";;"),
            nodes.linebreak(),

            nodes.tab(), nodes.text('"'), nodes.insert(4, "val2?"), nodes.text('")'),
            nodes.linebreak(),
            nodes.tab(2), nodes.insert(5, "what?"),
            nodes.linebreak(),
            nodes.tab(2), nodes.text(";;"),
            nodes.linebreak(),

            nodes.tab(), nodes.text("*)"),
            nodes.linebreak(),
            nodes.tab(2), nodes.insert(6, "exit 3"),
            nodes.linebreak(),
            nodes.tab(2), nodes.text(";;"),
            nodes.linebreak(),

            nodes.text("esac"),
            nodes.linebreak(),
            nodes.insert(0)
        }),
        snippet("whilecase", {
            nodes.text('while [ "${#}" -gt 0 ]; do'), nodes.linebreak(),
            nodes.tab(), nodes.text('case "${1}" in'), nodes.linebreak(),

            nodes.tab(2), nodes.text('"--'), nodes.insert(1, "opt1?"), nodes.text('")'), nodes.linebreak(),
            nodes.tab(3), nodes.insert(2, "var?"), nodes.text('="${2}"'), nodes.linebreak(),
            nodes.tab(3), nodes.text("shift && shift"), nodes.linebreak(),
            nodes.tab(3), nodes.text(";;"), nodes.linebreak(),

            nodes.tab(2), nodes.text('"--'), nodes.insert(3, "opt2?"), nodes.text('")'), nodes.linebreak(),
            nodes.tab(3), nodes.text("shift"), nodes.linebreak(),
            nodes.tab(3), nodes.insert(4, "var?"), nodes.text('="${1}"'), nodes.linebreak(),
            nodes.tab(3), nodes.text('shift'), nodes.linebreak(),
            nodes.tab(3), nodes.text(";;"), nodes.linebreak(),

            nodes.tab(2), nodes.text('"--")'), nodes.linebreak(),
            nodes.tab(3), nodes.text("shift && break"), nodes.linebreak(),
            nodes.tab(3), nodes.text(";;"), nodes.linebreak(),

            nodes.tab(2), nodes.text("*)"), nodes.linebreak(),
            nodes.tab(3), nodes.insert(5, "exit 3"), nodes.linebreak(),
            nodes.tab(3), nodes.text(";;"), nodes.linebreak(),

            nodes.tab(), nodes.text("esac"), nodes.linebreak(),
            nodes.text("done"), nodes.linebreak(),
            nodes.insert(0)
        }),

        snippet("shebang", {
            nodes.text("#!/usr/bin/env "), nodes.insert(1, "da"), nodes.text("sh"),
            nodes.linebreak(),
        }),
    }

    m_luasnip.add_snippets("sh", snippets)
end

local function python()
    local snippets = {
        snippet("definition", {
            nodes.text("from pathlib import Path"),
            nodes.linebreak(3),
            nodes.text("class Definition:"),
            nodes.linebreak(), nodes.tab(), nodes.text("SRC_DIR = Path(__file__).parent"),
            nodes.linebreak(2), nodes.tab(), nodes.text("ROOT_DIR = SRC_DIR.parent"),
            nodes.linebreak(), nodes.tab(), nodes.text('TEST_DIR = SRC_DIR.parent / "tests"'),
            nodes.linebreak(2), nodes.tab(), nodes.text('BIN_DIR = SRC_DIR.parent / "bin"'),
            nodes.linebreak(3),
            nodes.text("DEFINITION = Definition()"),
        }),

        snippet("importlog", {
            nodes.text("import logging"),
            nodes.linebreak(),
            nodes.text("logger = logging.getLogger(__name__)"),
        }),
        snippet("importpath", {
            nodes.text("from pathlib import Path"),
            nodes.linebreak(),
        }),
        snippet("importnp", {
            nodes.text("import numpy as np"),
            nodes.linebreak(),
        }),
        snippet("importplt", {
            nodes.text("import matplotlib.pyplot as plt"),
            nodes.linebreak(),
        }),
        snippet("importmpl", {
            nodes.text("import matplotlib as mpl"),
            nodes.linebreak(),
        }),
        snippet("importcallable", {
            nodes.text("from collections.abc import Callable"),
            nodes.linebreak(),
        }),
        snippet("importiterable", {
            nodes.text("from collections.abc import Iterable"),
            nodes.linebreak(),
        }),
        snippet("importsrc", {
            nodes.text("from src."),
            nodes.insert(1, "where?"),
            nodes.text(" import "),
            nodes.insert(2, "what?"),
            nodes.linebreak(),
        }),
        snippet("importdefinition", {
            nodes.text("from src.definition import DEFINITION"),
            nodes.linebreak(),
        }),

        snippet("cl", {
            nodes.text("class "),
            nodes.choice(1, {
                {
                    nodes.insert(1, "class?"),
                    nodes.text("("),
                    nodes.insert(2, "supercl?"),
                    nodes.text(")")
                },
                nodes.choice_insert("class?")
            }),
            nodes.text(":"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(2),
        }
        ),
        snippet("init", {
            nodes.text("def __init__(self"),
            nodes.choice(1, {
                { nodes.text(", "), nodes.insert(1, "args?") },
                nodes.choice_blank(),
            }),
            nodes.text("):"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(2),
        }
        ),
        snippet("super", {
            nodes.text("super("),
            nodes.choice(1, {
                nodes.choice_blank(),
                nodes.choice_insert("type?"),
            }),
            nodes.text(").__init__("),
            nodes.choice(2, {
                nodes.choice_insert("args?"),
                nodes.choice_blank(),
            }),
            nodes.text(")"),
            nodes.linebreak(2),
        }),
        snippet("repr", {
            nodes.text("def __repr__(self):"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(1, "what?"),
            nodes.linebreak(2),
        }),
        snippet("fn", {
            nodes.choice(1, {
                { nodes.text("def _"), nodes.insert(1, "fn?"), },
                { nodes.text("def "),  nodes.insert(1, "fn?"), },
            }),
            nodes.text("(self"),
            nodes.choice(2, {
                nodes.choice_blank(),
                nodes.choice_raw({ nodes.text(", "), nodes.insert(1, "args?"), }),
            }),
            nodes.text(")"),
            nodes.choice(3, {
                nodes.choice_text(" -> None"),
                nodes.choice_raw({ nodes.text(" -> "), nodes.insert(1, "what?"), }),
                nodes.choice_blank(),
            }),

            nodes.text(":"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(4, "what?"),
            nodes.linebreak(),
        }),

        snippet("fnstatic", {
            nodes.text("@staticmethod"),
            nodes.linebreak(),
            nodes.text("def "), nodes.insert(1, "fn?"), nodes.text("("), nodes.insert(2, "args?"), nodes.text(
            ") -> "), nodes.insert(3, "type?"),
            nodes.text(":"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(4, "what?"),
            nodes.linebreak(),
        }),
        snippet("fnclass", {
            nodes.text("@classmethod"),
            nodes.linebreak(),
            nodes.text("def "), nodes.insert(1, "fn?"), nodes.text("(cls, "), nodes.insert(2, "args?"), nodes.text(
            ") -> "), nodes.insert(3,
            "type?"), nodes.text(":"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(4, "what?"),
            nodes.linebreak(),
        }),
        snippet("prop", {
            nodes.text("@property"),
            nodes.linebreak(),
            nodes.text("def "), nodes.insert(1, "fn?"), nodes.text("(self) -> "), nodes.insert(3, "type?"), nodes
            .text(":"),
            nodes.linebreak(), nodes.tab(), nodes.text("return self._"), nodes.insert(2, "what?"),
            nodes.linebreak(),
        }
        ),

        snippet("testfn", {
            nodes.text("def test_"), nodes.insert(1, "fn?"), nodes.text("(self):"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(2),
        }),
        snippet("testcl", {
            nodes.text("class Test"), nodes.insert(1, "class?"), nodes.text(":"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(3),
        }),
        snippet("testraise", {
            nodes.text("with pytest.raises("), nodes.insert(1, "except?"), nodes.text(")"),
            nodes.linebreak(),
            nodes.tab(), nodes.insert(2, "what?"),
            nodes.linebreak(),
        }
        ),

        snippet("arg", {
            nodes.choice(1, {
                { nodes.insert(1, "var?"), nodes.text(": "), nodes.insert(2, "type?") },
                nodes.choice_insert("var?"),
            })
        }),
        snippet("tlist", {
            nodes.choice(1, {
                { nodes.text("list["), nodes.insert(1, "type?"), nodes.text("]") },
                nodes.choice_text("list"),
            })
        }),
        snippet("ttuple", {
            nodes.choice(1, {
                { nodes.text("tuple["), nodes.insert(1, "types?"), nodes.text("]") },
                nodes.choice_text("tuple"),
            })
        }),
        snippet("tdict", {
            nodes.text("dict["),
            nodes.insert(1, "key?"),
            nodes.text(", "),
            nodes.insert(2, "val?"),
            nodes.text("]")
        }),
        snippet("tgenerator", {
            nodes.text("Generator["),
            nodes.insert(1, "type?"),
            nodes.text(", None, None]")
        }),
        snippet("tdataset", {
            nodes.text("torch.utils.data.dataset.TensorDataset")
        }),
        snippet("tcallable", {
            nodes.text("Callable[["),
            nodes.insert(1, "args?"),
            nodes.text("], "),
            nodes.insert(2, "ret?"),
            nodes.text("]")
        }),
        snippet("tmatrix", {
            nodes.choice(1, {
                nodes.choice_text("np.ndarray"),
                nodes.choice_text("torch.Tensor"),
            })
        }),
        snippet("tfigure", {
            nodes.text("mpl.figure.Figure")
        }),
        snippet("taxes", {
            nodes.text("mpl.axes.Axes")
        }),
        snippet("tret", {
            nodes.text(" -> "),
            nodes.choice(1, {
                nodes.choice_insert("what?"),
                nodes.choice_text("None"),
            })
        }),

        snippet("__main__", {
            nodes.text('if __name__ == "__main__":'),
            nodes.linebreak(),
            nodes.choice(1, {
                {
                    nodes.tab(),
                    nodes.text(
                        'logging.basicConfig(format="%(module)s [%(levelname)s]> %(message)s", level=logging.'
                    ),
                    nodes.insert(1, "INFO"),
                    nodes.text(")"),
                    nodes.linebreak(2),
                },
                nodes.choice_blank(),
            }),
            nodes.tab(), nodes.insert(2, "what?")
        }),
    }

    m_luasnip.add_snippets("python", snippets)
end

local function java()
    local base = {
        snippet("cast/number", {
            nodes.choice(1, {
                nodes.text('Integer.parseInt("100");'),
                nodes.text('Double.parseDouble("100.0");'),
                nodes.text('Long.parseLong("100");'),
                nodes.text('Float.parseFloat("100.0");'),
            })
        }),

        snippet("string/repeat", {
            nodes.text("s2 = s1.repeat(3);"),
        }),
        snippet("string/join", {
            nodes.choice(1, {
                nodes.text('s = String.join(" - ", listOfStrings)'),
                nodes.text('s = String.join(" - ", listOfStrings)'),
            })
        }),
        snippet("string/substring", {
            nodes.text("s2 = s1.substring(1, s1.length() - 1);"),
        }),
        snippet("string/reverse", {
            nodes.text("s2 = new StringBuilder(s1).reverse().toString();"),
        }),

        snippet("fn/avg", {
            nodes.text("elements.stream().mapToDouble(e -> e).average().getAsDouble();"),
        }),
        snippet("fn/prod", {
            nodes.text("elements.stream().reduce(1, (e1, e2) -> e1 * e2 );"),
        }),
    }

    local array = {
        snippet("array", {
            nodes.choice(1, {
                nodes.text("Integer[] elements = { 1, 2 };"),
                { nodes.text("new Integer["),    nodes.insert(1, "count?"),  nodes.text("]") },
                { nodes.text("new Integer[] {"), nodes.insert(1, "e1, ..."), nodes.text("]") },
                nodes.text("new Integer[] { 1, 2 };"),
            }),
        }),
        snippet("array/copy", {
            nodes.text("Arrays.copyOf(from?, len?);"),
        }),
    }

    local list = {
        snippet("list", {
            nodes.text("List<"),
            nodes.choice(3, {
                { nodes.insert(1, "type?") },
                nodes.text("Integer"),
                nodes.text("String"),
                nodes.text("Double"),
            }),
            nodes.text("> "),
            nodes.insert(1, "name?"),
            nodes.text(" = new ArrayList<>(Arrays.asList("),
            nodes.choice(2, {
                nodes.insert(1, "e1, ..."),
                nodes.choice_blank(),
            }),
            nodes.text("));"),
        }),
        snippet("list/read", {
            nodes.choice(1, {
                nodes.text("elements.getFirst(); // elements.get(0)"),
                nodes.text("elements.getLast(); // elements.get(elements.size() - 1)"),
            })
        }),
        snippet("list/iter", {
            nodes.choice(1, {
                nodes.text("elements.forEach(e -> System.out.println(e));"),
                {
                    nodes.text("for (Integer e : elements) {"), nodes.linebreak(),
                    nodes.tab(), nodes.text("System.out.println(e);"), nodes.linebreak(),
                    nodes.text("}"),
                },
            })
        }),
        snippet("list/sort", {
            nodes.choice(1, {
                nodes.text("Collections.sort(elements);"),
                nodes.text("Collections.reverse(elements);"),
            })
        }),
        snippet("list/copyshallow", {
            nodes.choice(1, {
                nodes.text("elementsNew = new ArrayList<Integer>(elementsOld)"),
                nodes.text("elementsNew = elements.subList(1, elements.size() - 1)"),
            })
        }),
        snippet("list/append", {
            nodes.choice(1, {
                nodes.text("elements.add(2, 42);"),
                nodes.text("elements.addFirst(42);"),
                nodes.text("elements.addLast(42);"),
            })
        }),
        snippet("list/extend", {
            nodes.text("elements.addAll(Arrays.asList(10, 20));"),
        }),
        snippet("list/delete_one", {
            nodes.choice(1, {
                nodes.text("elements.remove(0);"),
                nodes.text("elements.remove((Object) 42);"),
            })
        }),
        snippet("list/delete_recurs", {
            nodes.choice(1, {
                {
                    nodes.text("while (elements.remove((Object) 42)) {"), nodes.linebreak(),
                    nodes.tab(), nodes.text(";"), nodes.linebreak(),
                    nodes.text("}"),
                },
                nodes.text("elements.removeIf(e -> e == 42);"),
                nodes.text("elements.clear();"),
            })
        }),
    }

    local dict = {
        snippet("dict", {
            nodes.text("HashMap<"),
            nodes.choice(3, {
                nodes.text("String"),
                { nodes.insert(2, "type_K?") },
            }),
            nodes.text(", "),
            nodes.choice(2, {
                nodes.text("Integer"),
                { nodes.insert(2, "type_V?") },
            }),
            nodes.text("> "),
            nodes.insert(1, "name?"),
            nodes.text(" = new HashMap<>();"),

            nodes.linebreak(),

            nodes.text("dict.put(\"a\", 42);"),
        }),
        snippet("dict/read", {
            nodes.text('if (dict.containsKey("k")) {'), nodes.linebreak(),
            nodes.text('    return dict.get("k");'), nodes.linebreak(),
            nodes.text('}'), nodes.linebreak(),
        }),
        snippet("dict/modify", {
            nodes.text('if (!dict.containsKey("x")) {'), nodes.linebreak(),
            nodes.text('    dict.put("x", 42);'), nodes.linebreak(),
            nodes.text('} else {'), nodes.linebreak(),
            nodes.text('    dict.put("x", dict.get("x") + 1));'), nodes.linebreak(),
            nodes.text('}'), nodes.linebreak(),
        }),
        snippet("dict/delete_one", {
            nodes.text('dict.remove("a");')
        }),
        snippet("dict/delete_recurs", {
            nodes.text('dict.entrySet().removeIf(kv -> kv.getValue() == 3);')
        }),

        snippet("dict/iter", {
            nodes.choice(1, {
                {
                    nodes.text('for (K k : dict.keySet()) {'), nodes.linebreak(),
                    nodes.text('    // k.toString();'), nodes.linebreak(),
                    nodes.text('    ;'), nodes.linebreak(),
                    nodes.text('}'), nodes.linebreak(),
                },
                {
                    nodes.text('for (V v : dict.values()) {'), nodes.linebreak(),
                    nodes.text('    // v.toString();'), nodes.linebreak(),
                    nodes.text('    ;'), nodes.linebreak(),
                    nodes.text('}'), nodes.linebreak(),
                },
                {
                    nodes.text('for (Map.Entry<K, V> kv : dict.entrySet()) {'), nodes.linebreak(),
                    nodes.text('    // kv.getKey().toString(); kv.getValue().toString()'), nodes.linebreak(),
                    nodes.text('    ;'), nodes.linebreak(),
                    nodes.text('}'), nodes.linebreak(),
                }
            }),
        }),
    }

    local kafka = {
        snippet("kafka/admin", {
            nodes.text(
                'admin.listTopics().names().get().stream().anyMatch(t -> t.equalsIgnoreCase("TOPIC"));'
            ), nodes
            .linebreak(),
            nodes.text('List<NewTopic> topics = Arrays.asList(new NewTopic("TOPIC", 1, (short) 1));'), nodes.linebreak(),
            nodes.text('admin.createTopics(topics);'), nodes.linebreak(),
        }),
        snippet("kafka/producer/config", {
            nodes.text("Properties props = new Properties();"), nodes.linebreak(),
            nodes.text('props.put("bootstrap.servers", "localhost:9092");'), nodes.linebreak(),
            nodes.text(
                'props.put(ProducerConfig.ACKS_CONFIG, "all/1/0"); // https://kafka.apache.org/documentation/#acks'
            ), nodes.linebreak(),
            nodes.text(
                'props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");'
            ), nodes.linebreak(),
            nodes.text(
                'props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");'
            ), nodes.linebreak(),
        }),
        snippet("kafka/producer/make", {
            nodes.text("Producer<String, String> producer = new KafkaProducer<>("), nodes.linebreak(),
            nodes.text("props, new StringSerializer(), new StringSerializer()"), nodes.linebreak(),
            nodes.text(");"), nodes.linebreak(),
        }),
        snippet("kafka/producer/record", {
            nodes.text("producer.send(new ProducerRecord<>(topic?, key?, value?));"), nodes.linebreak(),
        }),

        snippet("kafka/consumer/config", {
            nodes.text("Properties props = new Properties();"), nodes.linebreak(),
            nodes.text('props.put("bootstrap.servers", "localhost:9092");'), nodes.linebreak(),
            nodes.text('props.put("group.id", group?);'), nodes.linebreak(),
            nodes.text('props.put("auto.offset.reset", "latest/earliest");'), nodes.linebreak(),
            nodes.text(
                'props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");'
            ), nodes.linebreak(),
            nodes.text(
                'props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");'
            ), nodes.linebreak(),
        }),
        snippet("kafka/consumer/make", {
            nodes.text("KafkaConsumer<String, String> consumer = new KafkaConsumer<>("), nodes.linebreak(),
            nodes.text("props, new StringSerializer(), new StringSerializer()"), nodes.linebreak(),
            nodes.text(");"), nodes.linebreak(),
        }),
        snippet("kafka/consumer/subscribe", {
            nodes.text("consumer.subscribe(Arrays.asList(topic?));"), nodes.linebreak(),
        }),
        snippet("kafka/consumer/poll", {
            nodes.text(
                "ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(1000));"
            ), nodes.linebreak(),
            nodes.text('for (ConsumerRecord<String, String> record : records) {'), nodes.linebreak(),
            nodes.text("// .offset(); .key(); .value()"), nodes.linebreak(),
            nodes.text(";"), nodes.linebreak(),
            nodes.text("}"), nodes.linebreak(),
        }),
    }

    for _, snippets in ipairs({ base, array, list, dict, kafka }) do
        m_luasnip.add_snippets("java", snippets)
    end
end

local function mail()
    local snippets = {
        snippet("dear", {
            nodes.text("Dear "), nodes.insert(1, "who?"), nodes.text(":"),
            nodes.linebreak(2),
            nodes.insert(0, "what?"),
        }),
        snippet("dear_sir", {
            nodes.text("Dear Sir or Madam:"), nodes.linebreak(2),
        }),
        snippet("dear_mishra", {
            nodes.text("Dear Prof. Mishra:"),
            nodes.linebreak(2),
            nodes.text("Thanks for your mail!"),
            nodes.linebreak(2),
        }),

        snippet("thank_mail", {
            nodes.text("Thank you for your E-Mail. ")
        }),
        snippet("thank_fast", {
            nodes.text("Thank you for the swift response. ")
        }),
    }

    m_luasnip.add_snippets("mail", snippets)
end

local function main()
    shell()
    python()
    java()
    mail()
end
main()
