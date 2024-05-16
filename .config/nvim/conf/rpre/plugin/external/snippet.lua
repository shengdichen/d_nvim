local luasnip = require("luasnip")

local function snippets_collection()
    local spt = luasnip.snippet
    local n_sn = luasnip.snippet_node
    local n_is = luasnip.indent_snippet_node

    local n_t = luasnip.text_node
    local line_break = function(count)
        local text = {}
        for _ = 0, count do
            table.insert(text, "")
        end
        return n_t(text)
    end
    local tab = function(count)
        local text = string.rep(" ", count * 4)
        return n_t(text)
    end
    local n_i = luasnip.insert_node
    local n_f = luasnip.function_node

    local n_c = luasnip.choice_node
    local n_d = luasnip.dynamic_node
    local n_r = luasnip.restore_node

    local n_ct = function(msg)
        return n_sn(nil, { n_t(msg), n_i(1), })
    end

    local s_sh = {
        spt("scriptpath",
            {
                n_t({ 'SCRIPT_PATH="$(realpath "$(dirname "${0}")")"' }),
                line_break(1),
            }
        ),
        spt("scriptname",
            {
                n_t({ 'SCRIPT_NAME="$(basename "${0}")"' }),
                line_break(1),
            }
        ),
        spt("stowname",
            {
                n_c(1, {
                    n_sn(nil, {
                        n_t({ 'STOW_NAME="$(basename "${SCRIPT_PATH}")"' }),
                        line_break(2),
                        n_i(1),
                    }),
                    n_ct('"$(basename "${SCRIPT_PATH}")"'),
                    n_ct('$(basename "${SCRIPT_PATH}")'),
                }),
            }
        ),

        spt("var",
            n_c(1, {
                { n_t({ '"${' }), n_i(1, "var?"), n_t({ '}"' }), },
                { n_t({ "${" }),  n_i(1, "var?"), n_t({ "}" }), },
            })
        ),
        spt("v#",
            n_c(1, {
                n_ct('"${#}"'),
                n_ct("${#}"),
            })
        ),
        spt("v1",
            n_c(1, {
                n_ct('"${1}"'),
                n_ct("${1}"),
            })
        ),
        spt("v2",
            n_c(1, {
                n_ct('"${2}"'),
                n_ct("${2}"),
            })
        ),
        spt("v3",
            n_c(1, {
                n_ct('"${3}"'),
                n_ct("${3}"),
            })
        ),
        spt("v@",
            n_c(1, {
                n_ct('"${@}"'),
                n_ct("${@}"),
            })
        ),
        spt("v*",
            n_c(1, {
                n_ct('"${*}"'),
                n_ct("${*}"),
            })
        ),

        spt("fn",
            {
                n_i(1, "fn?"), n_t({ "() {" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
                n_t({ "}" }),
                line_break(1),
            }
        ),
        spt("fnret",
            n_c(1, {
                { n_t({ '"$(' }), n_i(1, "var?"), n_t({ ')"' }), },
                { n_t({ "$(" }),  n_i(1, "var?"), n_t({ ")" }), },
            })
        ),
        spt("sub",
            {
                n_t({ "(" }),
                line_break(1),
                tab(1), n_i(1, "what?"),
                line_break(1),
                n_t({ ")" }),
                line_break(1),
            }
        ),
        spt("cd",
            n_c(1, {
                {
                    n_t({ "cd " }), n_i(1, "where?"), n_t({ " || exit " }), n_i(2, "3"),
                    line_break(1),
                },
                {
                    n_t({ "cd " }), n_i(1, "where?"), n_t({ " && " }), n_i(2, "what?"),
                },
            })
        ),

        --  if $1; then
        --      $0
        --  fi
        spt("if",
            {
                n_t({ "if " }), n_i(1, "test?"), n_t({ "; then" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
                n_t({ "fi" }),
                line_break(1),
            }
        ),
        spt("if--",
            { n_t({ 'if [ "${1}" = "--" ]; then shift; fi' }), }
        ),

        spt("tt",
            { n_t({ "[ " }), n_i(1, "test?"), n_t({ " ]" }), }
        ),
        -- test: os
        spt("te",
            n_c(1, {
                { n_t({ "[ -e " }),   n_i(1, "path?"), n_t({ " ]" }), },
                { n_t({ "[ ! -e " }), n_i(1, "path?"), n_t({ " ]" }), },
            })
        ),
        spt("tf",
            n_c(1, {
                { n_t({ "[ -f " }),   n_i(1, "path?"), n_t({ " ]" }), },
                { n_t({ "[ ! -f " }), n_i(1, "path?"), n_t({ " ]" }), },
            })
        ),
        spt("td",
            n_c(1, {
                { n_t({ "[ -d " }),   n_i(1, "path?"), n_t({ " ]" }), },
                { n_t({ "[ ! -d " }), n_i(1, "path?"), n_t({ " ]" }), },
            })
        ),
        --  test: string
        spt("tstr",
            n_c(1, {
                { n_t({ "[ " }),   n_i(1, "str?"), n_t({ " ]" }), },
                { n_t({ "[ ! " }), n_i(1, "str?"), n_t({ " ]" }), },
            })
        ),
        spt("tstrtrue",
            { n_t({ "[ -n " }), n_i(1, "str?"), n_t({ " ]" }), }
        ),
        spt("tstrfalse",
            { n_t({ "[ -z " }), n_i(1, "str?"), n_t({ " ]" }), }
        ),
        spt("tstr==",
            { n_t({ "[ " }), n_i(1, "str?"), n_t({ " = " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("tstr!=",
            { n_t({ "[ " }), n_i(1, "str?"), n_t({ " != " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        -- test: algebraic
        spt("t==",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -eq " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t!=",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -ne " }), n_i(2, "value"), n_t({ " ]" }), }

        ),
        spt("t>",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -gt " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t>=",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -ge " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t<",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -lt " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t<=",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -le " }), n_i(2, "value"), n_t({ " ]" }), }
        ),

        -- REF:
        --  https://www.shellcheck.net/wiki/SC2044
        spt("forfind",
            {
                n_t("find "), n_i(1, "where?"),
                n_t(" -maxdepth "), n_i(2, "depth?"),
                n_t(" -type "), n_i(3, "type?"),
                n_t(' ! -name "$(printf "*\\n*")"'),
                n_t(" |"),
                line_break(1),

                tab(1), n_t('while IFS="" read -r _path; do'), line_break(1),
                tab(2), n_t('printf "> [%s]\\n" "${_path}"'), line_break(1),
                tab(2), n_i(4, "what?"), line_break(1),
                tab(1), n_t("done"), line_break(1),

                n_i(0)
            }
        ),
        spt("forfindtmp",
            {
                n_t('local _tmp="./_tmp"'), line_break(1),
                n_t('mkdir "${_tmp}"'), line_break(1),

                n_t("find "), n_i(1, "where?"),
                n_t(" -maxdepth "), n_i(2, "depth?"),
                n_t(" -type "), n_i(3, "type?"),
                n_t(' ! -name "$(printf "*\\n*")"'),
                n_t(' >"${_tmp}"'),
                line_break(1),

                n_t('while IFS="" read -r _path; do'), line_break(1),
                tab(1), n_t('printf "> [%s]\\n" "${_path}"'), line_break(1),
                tab(1), n_i(4, "what?"), line_break(1),
                n_t('done <"${_tmp}"'), line_break(1),

                n_t('rm "${_tmp}"'), line_break(1),
                n_i(0)
            }
        ),

        spt("while",
            {
                n_t("while "), n_i(1, "test?"), n_t("; do"),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
                n_t("done"),
                line_break(1),
                n_i(0)
            }
        ),
        spt("case",
            {
                n_t("case "), n_i(1, "var?"), n_t(" in"),
                line_break(1),

                tab(1), n_t('"'), n_i(2, "val1?"), n_t('")'),
                line_break(1),
                tab(2), n_i(3, "what?"),
                line_break(1),
                tab(2), n_t(";;"),
                line_break(1),

                tab(1), n_t('"'), n_i(4, "val2?"), n_t('")'),
                line_break(1),
                tab(2), n_i(5, "what?"),
                line_break(1),
                tab(2), n_t(";;"),
                line_break(1),

                tab(1), n_t("*)"),
                line_break(1),
                tab(2), n_i(6, "exit 3"),
                line_break(1),
                tab(2), n_t(";;"),
                line_break(1),

                n_t("esac"),
                line_break(1),
                n_i(0)
            }
        ),
        spt("whilecase",
            {
                n_t('while [ "${#}" -gt 0 ]; do'), line_break(1),
                tab(1), n_t('case "${1}" in'), line_break(1),

                tab(2), n_t('"--'), n_i(1, "opt1?"), n_t('")'), line_break(1),
                tab(3), n_i(2, "var?"), n_t('="${2}"'), line_break(1),
                tab(3), n_t("shift && shift"), line_break(1),
                tab(3), n_t(";;"), line_break(1),

                tab(2), n_t('"--'), n_i(3, "opt2?"), n_t('")'), line_break(1),
                tab(3), n_t("shift"), line_break(1),
                tab(3), n_i(4, "var?"), n_t('="${1}"'), line_break(1),
                tab(3), n_t('shift'), line_break(1),
                tab(3), n_t(";;"), line_break(1),

                tab(2), n_t('"--")'), line_break(1),
                tab(3), n_t("shift && break"), line_break(1),
                tab(3), n_t(";;"), line_break(1),

                tab(2), n_t("*)"), line_break(1),
                tab(3), n_i(5, "exit 3"), line_break(1),
                tab(3), n_t(";;"), line_break(1),

                tab(1), n_t("esac"), line_break(1),
                n_t("done"), line_break(1),
                n_i(0)
            }
        ),

        spt("shebang",
            {
                n_t({ "#!/usr/bin/env " }), n_i(1, "da"), n_t({ "sh" }),
                line_break(1),
            }
        ),

    }
    luasnip.add_snippets("sh", s_sh)

    local break_formatted = function(idx)
        n_is(
            idx,
            { n_t({ "", "" }) },
            ""
        )
    end
    local s_python = {
        spt("definition",
            {
                n_t({ "from pathlib import Path" }),
                line_break(3),
                n_t({ "class Definition:" }),
                line_break(1), tab(1), n_t({ "SRC_DIR = Path(__file__).parent" }),
                line_break(2), tab(1), n_t({ "ROOT_DIR = SRC_DIR.parent" }),
                line_break(1), tab(1), n_t({ 'TEST_DIR = SRC_DIR.parent / "tests"' }),
                line_break(2), tab(1), n_t({ 'BIN_DIR = SRC_DIR.parent / "bin"' }),
                line_break(3),
                n_t({ "DEFINITION = Definition()" }),
            }
        ),

        spt("importlog",
            {
                n_t({ "import logging" }),
                line_break(1),
                n_t({ "logger = logging.getLogger(__name__)" }),
            }
        ),
        spt("importpath",
            {
                n_t({ "from pathlib import Path" }),
                line_break(1),
            }
        ),
        spt("importnp",
            {
                n_t({ "import numpy as np" }),
                line_break(1),
            }
        ),
        spt("importplt",
            {
                n_t({ "import matplotlib.pyplot as plt" }),
                line_break(1),
            }
        ),
        spt("importmpl",
            {
                n_t({ "import matplotlib as mpl" }),
                line_break(1),
            }
        ),
        spt("importcallable",
            {
                n_t({ "from collections.abc import Callable" }),
                line_break(1),
            }
        ),
        spt("importiterable",
            {
                n_t({ "from collections.abc import Iterable" }),
                line_break(1),
            }
        ),
        spt("importsrc",
            {
                n_t({ "from src." }), n_i(1, "where?"), n_t({ " import " }), n_i(2, "what?"),
                line_break(1),
            }
        ),
        spt("importdefinition",
            {
                n_t({ "from src.definition import DEFINITION" }),
                line_break(1),
            }
        ),

        spt("cl",
            {
                n_t({ "class " }),
                n_c(1, {
                    n_sn(nil, { n_i(1, "class?"), n_t("("), n_i(2, "supercl?"), n_t(")") }),
                    n_i(nil, "class?"),
                }),
                n_t({ ":" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(2),
            }
        ),
        spt("init",
            {
                n_t({ "def __init__(self" }),
                n_c(1, {
                    n_sn(nil, { n_t(", "), n_i(1, "args?"), }),
                    n_i(nil),
                }),
                n_t({ "):" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(2),
            }
        ),
        spt("super",
            {
                n_t({ "super(" }),
                n_c(1, {
                    n_i(nil),
                    n_i(nil, "type?"),
                }),
                n_t({ ").__init__(" }),
                n_c(2, {
                    n_i(nil, "args?"),
                    n_i(nil),
                }),
                n_t({ ")" }),
                line_break(2),
            }
        ),
        spt("repr",
            {
                n_t({ "def __repr__(self):" }),
                line_break(1),
                tab(1), n_i(1, "what?"),
                line_break(2),
            }
        ),
        spt("fn",
            {
                n_c(1, {
                    { n_t({ "def _" }), n_i(1, "fn?"), },
                    { n_t({ "def " }),  n_i(1, "fn?"), },
                }),
                n_t({ "(self" }),
                n_c(2, {
                    n_i(nil),
                    n_sn(nil, { n_t(", "), n_i(1, "args?"), }),
                }),
                n_t({ ")" }),
                n_c(3, {
                    n_ct(" -> None"),
                    n_sn(nil, { n_t(" -> "), n_i(1, "what?"), }),
                    n_i(nil),
                }),

                n_t({ ":" }),
                line_break(1),
                tab(1), n_i(4, "what?"),
                line_break(1),
            }
        ),

        spt("fnstatic",
            {
                n_t("@staticmethod"),
                line_break(1),
                n_t("def "), n_i(1, "fn?"), n_t("("), n_i(2, "args?"), n_t(") -> "), n_i(3, "type?"), n_t(":"),
                line_break(1),
                tab(1), n_i(4, "what?"),
                line_break(1),
            }
        ),
        spt("fnclass",
            {
                n_t("@classmethod"),
                line_break(1),
                n_t("def "), n_i(1, "fn?"), n_t("(cls, "), n_i(2, "args?"), n_t(") -> "), n_i(3, "type?"), n_t(":"),
                line_break(1),
                tab(1), n_i(4, "what?"),
                line_break(1),
            }
        ),
        spt("prop",
            {
                n_t("@property"),
                line_break(1),
                n_t("def "), n_i(1, "fn?"), n_t("(self) -> "), n_i(3, "type?"), n_t(":"),
                line_break(1), tab(1), n_t("return self._"), n_i(2, "what?"),
                line_break(1),
            }
        ),

        spt("testfn",
            {
                n_t({ "def test_" }), n_i(1, "fn?"), n_t({ "(self):" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(2),
            }
        ),
        spt("testcl",
            {
                n_t({ "class Test" }), n_i(1, "class?"), n_t({ ":" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(3),
            }
        ),
        spt("testraise",
            {
                n_t({ "with pytest.raises(" }), n_i(1, "except?"), n_t({ ")" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
            }
        ),

        spt("arg",
            n_c(1, {
                { n_i(1, "var?"), n_t(": "), n_i(2, "type?") },
                { n_i(1, "var?") },
            })
        ),
        spt("tlist",
            n_c(1, {
                { n_t({ "list[" }), n_i(1, "type?"), n_t({ "]" }) },
                n_ct("list"),
            })
        ),
        spt("ttuple",
            n_c(1, {
                { n_t({ "tuple[" }), n_i(1, "types?"), n_t({ "]" }) },
                n_ct("tuple"),
            })
        ),
        spt("tdict",
            {
                n_t({ "dict[" }), n_i(1, "key?"), n_t({ ", " }), n_i(2, "val?"), n_t({ "]" }),
            }
        ),
        spt("tgenerator",
            { n_t({ "Generator[" }), n_i(1, "type?"), n_t({ ", None, None]" }) }
        ),
        spt("tdataset",
            { n_t({ "torch.utils.data.dataset.TensorDataset" }) }
        ),
        spt("tcallable",
            { n_t({ "Callable[[" }), n_i(1, "args?"), n_t({ "], " }), n_i(2, "ret?"), n_t({ "]" }) }
        ),
        spt("tmatrix",
            n_c(1, {
                n_ct("np.ndarray"),
                n_ct("torch.Tensor"),
            })
        ),
        spt("tfigure",
            { n_t({ "mpl.figure.Figure" }) }
        ),
        spt("taxes",
            { n_t({ "mpl.axes.Axes" }) }
        ),
        spt("tret",
            {
                n_t(" -> "),
                n_c(1, {
                    n_i(nil, "what?"),
                    n_ct("None"),
                })
            }
        ),

        spt("__main__",
            {
                n_t('if __name__ == "__main__":'),
                line_break(1),
                n_c(1, {
                    n_sn(nil, {
                        tab(1),
                        n_t(
                            'logging.basicConfig(format="%(module)s [%(levelname)s]> %(message)s", level=logging.'
                        ),
                        n_i(1, "INFO"),
                        n_t(")"),
                        line_break(2),
                    }),
                    n_i(nil),
                }),
                tab(1), n_i(2, "what?")
            }
        ),
    }
    luasnip.add_snippets("python", s_python)

    local s_mail = {
        spt("dear",
            {
                n_t({ "Dear " }), n_i(1, "who?"), n_t({ ":" }),
                line_break(2),
                n_i(0, "what?"),
            }
        ),
        spt("dear_sir",
            { n_t({ "Dear Sir or Madam:" }), line_break(2), }
        ),
        spt("dear_mishra",
            {
                n_t({ "Dear Prof. Mishra:" }),
                line_break(2),
                n_t({ "Thanks for your mail!" }),
                line_break(2),
            }
        ),

        spt("thank_mail",
            { n_t({ "Thank you for your E-Mail. " }), }
        ),
        spt("thank_fast", {
            n_t({ "Thank you for the swift response. " })
        }),
    }
    luasnip.add_snippets("mail", s_mail)
end

local function main()
    snippets_collection()
end
main()
