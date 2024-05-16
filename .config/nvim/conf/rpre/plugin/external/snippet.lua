local m_luasnip = require("luasnip")
local snippet = m_luasnip.snippet

local function make_nodes()
    local nodes = {
        text = m_luasnip.text_node,
        insert = m_luasnip.insert_node,
        choice = m_luasnip.choice_node,
        func = m_luasnip.function_node,
        dynamic = m_luasnip.dynamic_node,
        restore = m_luasnip.restore_node,
    }
    return nodes
end
local nodes = make_nodes()

local n_sn = m_luasnip.snippet_node
local n_is = m_luasnip.indent_snippet_node

local line_break = function(count)
    local text = {}
    for _ = 0, count or 1 do
        table.insert(text, "")
    end
    return nodes.text(text)
end

local tab = function(count)
    local text = string.rep(" ", count * 4)
    return nodes.text(text)
end

local n_ct = function(msg)
    return n_sn(nil, { nodes.text(msg), nodes.insert(1), })
end

local break_formatted = function(idx)
    n_is(
        idx,
        { nodes.text({ "", "" }) },
        ""
    )
end

local function shell()
    local snippets = {
        snippet("scriptpath",
            {
                nodes.text({ 'SCRIPT_PATH="$(realpath "$(dirname "${0}")")"' }),
                line_break(),
            }
        ),
        snippet("scriptname",
            {
                nodes.text({ 'SCRIPT_NAME="$(basename "${0}")"' }),
                line_break(),
            }
        ),
        snippet("stowname",
            {
                nodes.choice(1, {
                    n_sn(nil, {
                        nodes.text({ 'STOW_NAME="$(basename "${SCRIPT_PATH}")"' }),
                        line_break(2),
                        nodes.insert(1),
                    }),
                    n_ct('"$(basename "${SCRIPT_PATH}")"'),
                    n_ct('$(basename "${SCRIPT_PATH}")'),
                }),
            }
        ),

        snippet("var",
            nodes.choice(1, {
                { nodes.text({ '"${' }), nodes.insert(1, "var?"), nodes.text({ '}"' }), },
                { nodes.text({ "${" }),  nodes.insert(1, "var?"), nodes.text({ "}" }), },
            })
        ),
        snippet("v#",
            nodes.choice(1, {
                n_ct('"${#}"'),
                n_ct("${#}"),
            })
        ),
        snippet("v1",
            nodes.choice(1, {
                n_ct('"${1}"'),
                n_ct("${1}"),
            })
        ),
        snippet("v2",
            nodes.choice(1, {
                n_ct('"${2}"'),
                n_ct("${2}"),
            })
        ),
        snippet("v3",
            nodes.choice(1, {
                n_ct('"${3}"'),
                n_ct("${3}"),
            })
        ),
        snippet("v@",
            nodes.choice(1, {
                n_ct('"${@}"'),
                n_ct("${@}"),
            })
        ),
        snippet("v*",
            nodes.choice(1, {
                n_ct('"${*}"'),
                n_ct("${*}"),
            })
        ),

        snippet("fn",
            {
                nodes.insert(1, "fn?"), nodes.text({ "() {" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(1),
                nodes.text({ "}" }),
                line_break(1),
            }
        ),
        snippet("fnret",
            nodes.choice(1, {
                { nodes.text({ '"$(' }), nodes.insert(1, "var?"), nodes.text({ ')"' }), },
                { nodes.text({ "$(" }),  nodes.insert(1, "var?"), nodes.text({ ")" }), },
            })
        ),
        snippet("sub",
            {
                nodes.text({ "(" }),
                line_break(1),
                tab(1), nodes.insert(1, "what?"),
                line_break(1),
                nodes.text({ ")" }),
                line_break(1),
            }
        ),
        snippet("cd",
            nodes.choice(1, {
                {
                    nodes.text({ "cd " }), nodes.insert(1, "where?"), nodes.text({ " || exit " }), nodes.insert(2, "3"),
                    line_break(1),
                },
                {
                    nodes.text({ "cd " }), nodes.insert(1, "where?"), nodes.text({ " && " }), nodes.insert(2, "what?"),
                },
            })
        ),

        --  if $1; then
        --      $0
        --  fi
        snippet("if",
            {
                nodes.text({ "if " }), nodes.insert(1, "test?"), nodes.text({ "; then" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(1),
                nodes.text({ "fi" }),
                line_break(1),
            }
        ),
        snippet("if--",
            { nodes.text({ 'if [ "${1}" = "--" ]; then shift; fi' }), }
        ),

        snippet("tt",
            { nodes.text({ "[ " }), nodes.insert(1, "test?"), nodes.text({ " ]" }), }
        ),
        -- test: os
        snippet("te",
            nodes.choice(1, {
                { nodes.text({ "[ -e " }),   nodes.insert(1, "path?"), nodes.text({ " ]" }), },
                { nodes.text({ "[ ! -e " }), nodes.insert(1, "path?"), nodes.text({ " ]" }), },
            })
        ),
        snippet("tf",
            nodes.choice(1, {
                { nodes.text({ "[ -f " }),   nodes.insert(1, "path?"), nodes.text({ " ]" }), },
                { nodes.text({ "[ ! -f " }), nodes.insert(1, "path?"), nodes.text({ " ]" }), },
            })
        ),
        snippet("td",
            nodes.choice(1, {
                { nodes.text({ "[ -d " }),   nodes.insert(1, "path?"), nodes.text({ " ]" }), },
                { nodes.text({ "[ ! -d " }), nodes.insert(1, "path?"), nodes.text({ " ]" }), },
            })
        ),
        --  test: string
        snippet("tstr",
            nodes.choice(1, {
                { nodes.text({ "[ " }),   nodes.insert(1, "str?"), nodes.text({ " ]" }), },
                { nodes.text({ "[ ! " }), nodes.insert(1, "str?"), nodes.text({ " ]" }), },
            })
        ),
        snippet("tstrtrue",
            { nodes.text({ "[ -n " }), nodes.insert(1, "str?"), nodes.text({ " ]" }), }
        ),
        snippet("tstrfalse",
            { nodes.text({ "[ -z " }), nodes.insert(1, "str?"), nodes.text({ " ]" }), }
        ),
        snippet("tstr==",
            { nodes.text({ "[ " }), nodes.insert(1, "str?"), nodes.text({ " = " }), nodes.insert(2, "value"), nodes.text({
                " ]" }), }
        ),
        snippet("tstr!=",
            { nodes.text({ "[ " }), nodes.insert(1, "str?"), nodes.text({ " != " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }
        ),
        -- test: algebraic
        snippet("t==",
            { nodes.text({ "[ " }), nodes.insert(1, "var?"), nodes.text({ " -eq " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }
        ),
        snippet("t!=",
            { nodes.text({ "[ " }), nodes.insert(1, "var?"), nodes.text({ " -ne " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }

        ),
        snippet("t>",
            { nodes.text({ "[ " }), nodes.insert(1, "var?"), nodes.text({ " -gt " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }
        ),
        snippet("t>=",
            { nodes.text({ "[ " }), nodes.insert(1, "var?"), nodes.text({ " -ge " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }
        ),
        snippet("t<",
            { nodes.text({ "[ " }), nodes.insert(1, "var?"), nodes.text({ " -lt " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }
        ),
        snippet("t<=",
            { nodes.text({ "[ " }), nodes.insert(1, "var?"), nodes.text({ " -le " }), nodes.insert(2, "value"), nodes
                .text({ " ]" }), }
        ),

        -- REF:
        --  https://www.shellcheck.net/wiki/SC2044
        snippet("forfind",
            {
                nodes.text("find "), nodes.insert(1, "where?"),
                nodes.text(" -maxdepth "), nodes.insert(2, "depth?"),
                nodes.text(" -type "), nodes.insert(3, "type?"),
                nodes.text(' ! -name "$(printf "*\\n*")"'),
                nodes.text(" |"),
                line_break(1),

                tab(1), nodes.text('while IFS="" read -r _path; do'), line_break(1),
                tab(2), nodes.text('printf "> [%s]\\n" "${_path}"'), line_break(1),
                tab(2), nodes.insert(4, "what?"), line_break(1),
                tab(1), nodes.text("done"), line_break(1),

                nodes.insert(0)
            }
        ),
        snippet("forfindtmp",
            {
                nodes.text('local _tmp="./_tmp"'), line_break(1),
                nodes.text('mkdir "${_tmp}"'), line_break(1),

                nodes.text("find "), nodes.insert(1, "where?"),
                nodes.text(" -maxdepth "), nodes.insert(2, "depth?"),
                nodes.text(" -type "), nodes.insert(3, "type?"),
                nodes.text(' ! -name "$(printf "*\\n*")"'),
                nodes.text(' >"${_tmp}"'),
                line_break(1),

                nodes.text('while IFS="" read -r _path; do'), line_break(1),
                tab(1), nodes.text('printf "> [%s]\\n" "${_path}"'), line_break(1),
                tab(1), nodes.insert(4, "what?"), line_break(1),
                nodes.text('done <"${_tmp}"'), line_break(1),

                nodes.text('rm "${_tmp}"'), line_break(1),
                nodes.insert(0)
            }
        ),

        snippet("while",
            {
                nodes.text("while "), nodes.insert(1, "test?"), nodes.text("; do"),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(1),
                nodes.text("done"),
                line_break(1),
                nodes.insert(0)
            }
        ),
        snippet("case",
            {
                nodes.text("case "), nodes.insert(1, "var?"), nodes.text(" in"),
                line_break(1),

                tab(1), nodes.text('"'), nodes.insert(2, "val1?"), nodes.text('")'),
                line_break(1),
                tab(2), nodes.insert(3, "what?"),
                line_break(1),
                tab(2), nodes.text(";;"),
                line_break(1),

                tab(1), nodes.text('"'), nodes.insert(4, "val2?"), nodes.text('")'),
                line_break(1),
                tab(2), nodes.insert(5, "what?"),
                line_break(1),
                tab(2), nodes.text(";;"),
                line_break(1),

                tab(1), nodes.text("*)"),
                line_break(1),
                tab(2), nodes.insert(6, "exit 3"),
                line_break(1),
                tab(2), nodes.text(";;"),
                line_break(1),

                nodes.text("esac"),
                line_break(1),
                nodes.insert(0)
            }
        ),
        snippet("whilecase",
            {
                nodes.text('while [ "${#}" -gt 0 ]; do'), line_break(1),
                tab(1), nodes.text('case "${1}" in'), line_break(1),

                tab(2), nodes.text('"--'), nodes.insert(1, "opt1?"), nodes.text('")'), line_break(1),
                tab(3), nodes.insert(2, "var?"), nodes.text('="${2}"'), line_break(1),
                tab(3), nodes.text("shift && shift"), line_break(1),
                tab(3), nodes.text(";;"), line_break(1),

                tab(2), nodes.text('"--'), nodes.insert(3, "opt2?"), nodes.text('")'), line_break(1),
                tab(3), nodes.text("shift"), line_break(1),
                tab(3), nodes.insert(4, "var?"), nodes.text('="${1}"'), line_break(1),
                tab(3), nodes.text('shift'), line_break(1),
                tab(3), nodes.text(";;"), line_break(1),

                tab(2), nodes.text('"--")'), line_break(1),
                tab(3), nodes.text("shift && break"), line_break(1),
                tab(3), nodes.text(";;"), line_break(1),

                tab(2), nodes.text("*)"), line_break(1),
                tab(3), nodes.insert(5, "exit 3"), line_break(1),
                tab(3), nodes.text(";;"), line_break(1),

                tab(1), nodes.text("esac"), line_break(1),
                nodes.text("done"), line_break(1),
                nodes.insert(0)
            }
        ),

        snippet("shebang",
            {
                nodes.text({ "#!/usr/bin/env " }), nodes.insert(1, "da"), nodes.text({ "sh" }),
                line_break(1),
            }
        ),

    }

    m_luasnip.add_snippets("sh", snippets)
end

local function python()
    local snippets = {
        snippet("definition",
            {
                nodes.text({ "from pathlib import Path" }),
                line_break(3),
                nodes.text({ "class Definition:" }),
                line_break(1), tab(1), nodes.text({ "SRC_DIR = Path(__file__).parent" }),
                line_break(2), tab(1), nodes.text({ "ROOT_DIR = SRC_DIR.parent" }),
                line_break(1), tab(1), nodes.text({ 'TEST_DIR = SRC_DIR.parent / "tests"' }),
                line_break(2), tab(1), nodes.text({ 'BIN_DIR = SRC_DIR.parent / "bin"' }),
                line_break(3),
                nodes.text({ "DEFINITION = Definition()" }),
            }
        ),

        snippet("importlog",
            {
                nodes.text({ "import logging" }),
                line_break(1),
                nodes.text({ "logger = logging.getLogger(__name__)" }),
            }
        ),
        snippet("importpath",
            {
                nodes.text({ "from pathlib import Path" }),
                line_break(1),
            }
        ),
        snippet("importnp",
            {
                nodes.text({ "import numpy as np" }),
                line_break(1),
            }
        ),
        snippet("importplt",
            {
                nodes.text({ "import matplotlib.pyplot as plt" }),
                line_break(1),
            }
        ),
        snippet("importmpl",
            {
                nodes.text({ "import matplotlib as mpl" }),
                line_break(1),
            }
        ),
        snippet("importcallable",
            {
                nodes.text({ "from collections.abc import Callable" }),
                line_break(1),
            }
        ),
        snippet("importiterable",
            {
                nodes.text({ "from collections.abc import Iterable" }),
                line_break(1),
            }
        ),
        snippet("importsrc",
            {
                nodes.text({ "from src." }), nodes.insert(1, "where?"), nodes.text({ " import " }), nodes.insert(2,
                "what?"),
                line_break(1),
            }
        ),
        snippet("importdefinition",
            {
                nodes.text({ "from src.definition import DEFINITION" }),
                line_break(1),
            }
        ),

        snippet("cl",
            {
                nodes.text({ "class " }),
                nodes.choice(1, {
                    n_sn(nil,
                        { nodes.insert(1, "class?"), nodes.text("("), nodes.insert(2, "supercl?"), nodes.text(")") }),
                    nodes.insert(nil, "class?"),
                }),
                nodes.text({ ":" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(2),
            }
        ),
        snippet("init",
            {
                nodes.text({ "def __init__(self" }),
                nodes.choice(1, {
                    n_sn(nil, { nodes.text(", "), nodes.insert(1, "args?"), }),
                    nodes.insert(nil),
                }),
                nodes.text({ "):" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(2),
            }
        ),
        snippet("super",
            {
                nodes.text({ "super(" }),
                nodes.choice(1, {
                    nodes.insert(nil),
                    nodes.insert(nil, "type?"),
                }),
                nodes.text({ ").__init__(" }),
                nodes.choice(2, {
                    nodes.insert(nil, "args?"),
                    nodes.insert(nil),
                }),
                nodes.text({ ")" }),
                line_break(2),
            }
        ),
        snippet("repr",
            {
                nodes.text({ "def __repr__(self):" }),
                line_break(1),
                tab(1), nodes.insert(1, "what?"),
                line_break(2),
            }
        ),
        snippet("fn",
            {
                nodes.choice(1, {
                    { nodes.text({ "def _" }), nodes.insert(1, "fn?"), },
                    { nodes.text({ "def " }),  nodes.insert(1, "fn?"), },
                }),
                nodes.text({ "(self" }),
                nodes.choice(2, {
                    nodes.insert(nil),
                    n_sn(nil, { nodes.text(", "), nodes.insert(1, "args?"), }),
                }),
                nodes.text({ ")" }),
                nodes.choice(3, {
                    n_ct(" -> None"),
                    n_sn(nil, { nodes.text(" -> "), nodes.insert(1, "what?"), }),
                    nodes.insert(nil),
                }),

                nodes.text({ ":" }),
                line_break(1),
                tab(1), nodes.insert(4, "what?"),
                line_break(1),
            }
        ),

        snippet("fnstatic",
            {
                nodes.text("@staticmethod"),
                line_break(1),
                nodes.text("def "), nodes.insert(1, "fn?"), nodes.text("("), nodes.insert(2, "args?"), nodes.text(
                ") -> "), nodes.insert(3, "type?"),
                nodes.text(":"),
                line_break(1),
                tab(1), nodes.insert(4, "what?"),
                line_break(1),
            }
        ),
        snippet("fnclass",
            {
                nodes.text("@classmethod"),
                line_break(1),
                nodes.text("def "), nodes.insert(1, "fn?"), nodes.text("(cls, "), nodes.insert(2, "args?"), nodes.text(
                ") -> "), nodes.insert(3,
                "type?"), nodes.text(":"),
                line_break(1),
                tab(1), nodes.insert(4, "what?"),
                line_break(1),
            }
        ),
        snippet("prop",
            {
                nodes.text("@property"),
                line_break(1),
                nodes.text("def "), nodes.insert(1, "fn?"), nodes.text("(self) -> "), nodes.insert(3, "type?"), nodes
                .text(":"),
                line_break(1), tab(1), nodes.text("return self._"), nodes.insert(2, "what?"),
                line_break(1),
            }
        ),

        snippet("testfn",
            {
                nodes.text({ "def test_" }), nodes.insert(1, "fn?"), nodes.text({ "(self):" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(2),
            }
        ),
        snippet("testcl",
            {
                nodes.text({ "class Test" }), nodes.insert(1, "class?"), nodes.text({ ":" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(3),
            }
        ),
        snippet("testraise",
            {
                nodes.text({ "with pytest.raises(" }), nodes.insert(1, "except?"), nodes.text({ ")" }),
                line_break(1),
                tab(1), nodes.insert(2, "what?"),
                line_break(1),
            }
        ),

        snippet("arg",
            nodes.choice(1, {
                { nodes.insert(1, "var?"), nodes.text(": "), nodes.insert(2, "type?") },
                { nodes.insert(1, "var?") },
            })
        ),
        snippet("tlist",
            nodes.choice(1, {
                { nodes.text({ "list[" }), nodes.insert(1, "type?"), nodes.text({ "]" }) },
                n_ct("list"),
            })
        ),
        snippet("ttuple",
            nodes.choice(1, {
                { nodes.text({ "tuple[" }), nodes.insert(1, "types?"), nodes.text({ "]" }) },
                n_ct("tuple"),
            })
        ),
        snippet("tdict",
            {
                nodes.text({ "dict[" }), nodes.insert(1, "key?"), nodes.text({ ", " }), nodes.insert(2, "val?"), nodes
                .text({ "]" }),
            }
        ),
        snippet("tgenerator",
            { nodes.text({ "Generator[" }), nodes.insert(1, "type?"), nodes.text({ ", None, None]" }) }
        ),
        snippet("tdataset",
            { nodes.text({ "torch.utils.data.dataset.TensorDataset" }) }
        ),
        snippet("tcallable",
            { nodes.text({ "Callable[[" }), nodes.insert(1, "args?"), nodes.text({ "], " }), nodes.insert(2, "ret?"),
                nodes.text({ "]" }) }
        ),
        snippet("tmatrix",
            nodes.choice(1, {
                n_ct("np.ndarray"),
                n_ct("torch.Tensor"),
            })
        ),
        snippet("tfigure",
            { nodes.text({ "mpl.figure.Figure" }) }
        ),
        snippet("taxes",
            { nodes.text({ "mpl.axes.Axes" }) }
        ),
        snippet("tret",
            {
                nodes.text(" -> "),
                nodes.choice(1, {
                    nodes.insert(nil, "what?"),
                    n_ct("None"),
                })
            }
        ),

        snippet("__main__",
            {
                nodes.text('if __name__ == "__main__":'),
                line_break(1),
                nodes.choice(1, {
                    n_sn(nil, {
                        tab(1),
                        nodes.text(
                            'logging.basicConfig(format="%(module)s [%(levelname)s]> %(message)s", level=logging.'
                        ),
                        nodes.insert(1, "INFO"),
                        nodes.text(")"),
                        line_break(2),
                    }),
                    nodes.insert(nil),
                }),
                tab(1), nodes.insert(2, "what?")
            }
        ),
    }

    m_luasnip.add_snippets("python", snippets)
end

local function mail()
    local snippets = {
        snippet("dear",
            {
                nodes.text({ "Dear " }), nodes.insert(1, "who?"), nodes.text({ ":" }),
                line_break(2),
                nodes.insert(0, "what?"),
            }
        ),
        snippet("dear_sir",
            { nodes.text({ "Dear Sir or Madam:" }), line_break(2), }
        ),
        snippet("dear_mishra",
            {
                nodes.text({ "Dear Prof. Mishra:" }),
                line_break(2),
                nodes.text({ "Thanks for your mail!" }),
                line_break(2),
            }
        ),

        snippet("thank_mail",
            { nodes.text({ "Thank you for your E-Mail. " }), }
        ),
        snippet("thank_fast", {
            nodes.text({ "Thank you for the swift response. " })
        }),
    }

    m_luasnip.add_snippets("mail", snippets)
end

local function main()
    shell()
    python()
    mail()
end
main()
