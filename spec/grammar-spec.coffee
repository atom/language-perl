describe "Perl grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl"

  describe "when a regexp compile tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine("qr/text/acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.perl", "string.regexp.compile.simple-delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.perl", "string.regexp.compile.simple-delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.compile.simple-delimiter.perl"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.perl", "string.regexp.compile.simple-delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.compile.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("qr(text)acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "(", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl"]
      expect(tokens[3]).toEqual value: ")", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.compile.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("qr{text}acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.perl", "string.regexp.compile.nested_braces.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "{", scopes: ["source.perl", "string.regexp.compile.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.compile.nested_braces.perl"]
      expect(tokens[3]).toEqual value: "}", scopes: ["source.perl", "string.regexp.compile.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.compile.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("qr[text]acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.perl", "string.regexp.compile.nested_brackets.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "[", scopes: ["source.perl", "string.regexp.compile.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.compile.nested_brackets.perl"]
      expect(tokens[3]).toEqual value: "]", scopes: ["source.perl", "string.regexp.compile.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.compile.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("qr<text>acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: "qr", scopes: ["source.perl", "string.regexp.compile.nested_ltgt.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "<", scopes: ["source.perl", "string.regexp.compile.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.compile.nested_ltgt.perl"]
      expect(tokens[3]).toEqual value: ">", scopes: ["source.perl", "string.regexp.compile.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.compile.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.perl"]

    it "does not treat $) as a variable", ->
      {tokens} = grammar.tokenizeLine("qr(^text$);")
      expect(tokens[2]).toEqual value: "^text", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl"]
      expect(tokens[3]).toEqual value: "$", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl"]
      expect(tokens[4]).toEqual value: ")", scopes: ["source.perl", "string.regexp.compile.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: ";", scopes: ["source.perl"]

    it "does not treat ( in a class as a group", ->
      {tokens} = grammar.tokenizeLine("m/ \\A [(]? [?] .* - /smx")
      expect(tokens[1]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "[", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl"]
      expect(tokens[6]).toEqual value: "(", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl"]
      expect(tokens[7]).toEqual value: "]", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl"]
      expect(tokens[13]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[14]).toEqual value: "smx", scopes: ["source.perl", "string.regexp.find-m.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

    it "does not treat 'm'(hashkey) as a regex match begin", ->
      {tokens} = grammar.tokenizeLine("$foo->{m}->bar();")
      expect(tokens[3]).toEqual value: "{", scopes: ["source.perl"]
      expect(tokens[4]).toEqual value: "m", scopes: ["source.perl", "constant.other.bareword.perl"]
      expect(tokens[5]).toEqual value: "}", scopes: ["source.perl"]

    it "does not treat '#' as a comment in regex match", ->
      {tokens} = grammar.tokenizeLine("$asd =~ s#asd#foo#;")
      expect(tokens[3]).toEqual value: "s", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[4]).toEqual value: "#", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[6]).toEqual value: "#", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[8]).toEqual value: "#", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]

  describe "when a regexp find tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine(" =~ /text/acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: " =~", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.perl"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine(" =~ m/text/acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find-m.simple-delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.find-m.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine(" =~ m(text)acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.perl", "string.regexp.find-m.nested_parens.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[2]).toEqual value: "(", scopes: ["source.perl", "string.regexp.find-m.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.perl", "string.regexp.find-m.nested_parens.perl"]
      expect(tokens[4]).toEqual value: ")", scopes: ["source.perl", "string.regexp.find-m.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.find-m.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine(" =~ m{text}acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.perl", "string.regexp.find-m.nested_braces.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[2]).toEqual value: "{", scopes: ["source.perl", "string.regexp.find-m.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.perl", "string.regexp.find-m.nested_braces.perl"]
      expect(tokens[4]).toEqual value: "}", scopes: ["source.perl", "string.regexp.find-m.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.find-m.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine(" =~ m[text]acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.perl", "string.regexp.find-m.nested_brackets.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[2]).toEqual value: "[", scopes: ["source.perl", "string.regexp.find-m.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.perl", "string.regexp.find-m.nested_brackets.perl"]
      expect(tokens[4]).toEqual value: "]", scopes: ["source.perl", "string.regexp.find-m.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.find-m.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine(" =~ m<text>acdegilmnoprsux;")
      expect(tokens[0]).toEqual value: " =~ ", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: "m", scopes: ["source.perl", "string.regexp.find-m.nested_ltgt.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[2]).toEqual value: "<", scopes: ["source.perl", "string.regexp.find-m.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "text", scopes: ["source.perl", "string.regexp.find-m.nested_ltgt.perl"]
      expect(tokens[4]).toEqual value: ">", scopes: ["source.perl", "string.regexp.find-m.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.find-m.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ";", scopes: ["source.perl"]

    it "works with without any character before a regexp", ->
      {tokens} = grammar.tokenizeLine("/asd/")
      expect(tokens[0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[1]).toEqual value: "asd", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]

      {tokens} = grammar.tokenizeLine(" /asd/")
      expect(tokens[0]).toEqual value: " ", scopes: ["source.perl"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "asd", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]

      lines = grammar.tokenizeLines("""$asd =~
      /asd/;""")
      expect(lines[0][2]).toEqual value: " =~", scopes: ["source.perl"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(lines[1][1]).toEqual value: "asd", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(lines[1][2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(lines[1][3]).toEqual value: ";", scopes: ["source.perl"]

    it "works with control keys before a regexp", ->
      {tokens} = grammar.tokenizeLine("if /asd/")
      expect(tokens[1]).toEqual value: " ", scopes: ["source.perl"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "asd", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]

      {tokens} = grammar.tokenizeLine("unless /asd/")
      expect(tokens[1]).toEqual value: " ", scopes: ["source.perl"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: "asd", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]

    it "works with multiline regexp", ->
      lines = grammar.tokenizeLines("""$asd =~ /
      (\\d)
      /x""")
      expect(lines[0][2]).toEqual value: " =~", scopes: ["source.perl"]
      expect(lines[0][3]).toEqual value: " ", scopes: ["source.perl"]
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(lines[1][0]).toEqual value: "(", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(lines[1][2]).toEqual value: ")", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(lines[2][0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(lines[2][1]).toEqual value: "x", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

    it "does not highlight a divide operation", ->
      {tokens} = grammar.tokenizeLine("my $foo = scalar(@bar)/2;")
      expect(tokens[9]).toEqual value: ")/2;", scopes: ["source.perl"]

    it "works in a if", ->
      {tokens} = grammar.tokenizeLine("if (/ hello /i) {}")
      expect(tokens[1]).toEqual value: " (", scopes: ["source.perl"]
      expect(tokens[2]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[3]).toEqual value: " hello ", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "i", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[6]).toEqual value: ") {}", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("if ($_ && / hello /i) {}")
      expect(tokens[5]).toEqual value: " ", scopes: ["source.perl"]
      expect(tokens[6]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[7]).toEqual value: " hello ", scopes: ["source.perl", "string.regexp.find.perl"]
      expect(tokens[8]).toEqual value: "/", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl"]
      expect(tokens[9]).toEqual value: "i", scopes: ["source.perl", "string.regexp.find.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]
      expect(tokens[10]).toEqual value: ") {}", scopes: ["source.perl"]

  describe "when a regexp replace tokenizes", ->
    it "works with all bracket/seperator variations", ->
      {tokens} = grammar.tokenizeLine("s/text/test/acdegilmnoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl"]
      expect(tokens[3]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "test", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl"]
      expect(tokens[5]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[6]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

      {tokens} = grammar.tokenizeLine("s(text)(test)acdegilmnoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.nested_parens.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "(", scopes: ["source.perl", "string.regexp.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.nested_parens.perl"]
      expect(tokens[3]).toEqual value: ")", scopes: ["source.perl", "string.regexp.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "(", scopes: ["source.perl", "string.regexp.format.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.perl", "string.regexp.format.nested_parens.perl"]
      expect(tokens[6]).toEqual value: ")", scopes: ["source.perl", "string.regexp.format.nested_parens.perl", "punctuation.definition.string.perl"]
      expect(tokens[7]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

      {tokens} = grammar.tokenizeLine("s{text}{test}acdegilmnoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.nested_braces.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "{", scopes: ["source.perl", "string.regexp.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.nested_braces.perl"]
      expect(tokens[3]).toEqual value: "}", scopes: ["source.perl", "string.regexp.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "{", scopes: ["source.perl", "string.regexp.format.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.perl", "string.regexp.format.nested_braces.perl"]
      expect(tokens[6]).toEqual value: "}", scopes: ["source.perl", "string.regexp.format.nested_braces.perl", "punctuation.definition.string.perl"]
      expect(tokens[7]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

      {tokens} = grammar.tokenizeLine("s[text][test]acdegilmnoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.nested_brackets.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "[", scopes: ["source.perl", "string.regexp.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.nested_brackets.perl"]
      expect(tokens[3]).toEqual value: "]", scopes: ["source.perl", "string.regexp.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "[", scopes: ["source.perl", "string.regexp.format.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.perl", "string.regexp.format.nested_brackets.perl"]
      expect(tokens[6]).toEqual value: "]", scopes: ["source.perl", "string.regexp.format.nested_brackets.perl", "punctuation.definition.string.perl"]
      expect(tokens[7]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

      {tokens} = grammar.tokenizeLine("s<text><test>acdegilmnoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.nested_ltgt.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "<", scopes: ["source.perl", "string.regexp.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.nested_ltgt.perl"]
      expect(tokens[3]).toEqual value: ">", scopes: ["source.perl", "string.regexp.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "<", scopes: ["source.perl", "string.regexp.format.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[5]).toEqual value: "test", scopes: ["source.perl", "string.regexp.format.nested_ltgt.perl"]
      expect(tokens[6]).toEqual value: ">", scopes: ["source.perl", "string.regexp.format.nested_ltgt.perl", "punctuation.definition.string.perl"]
      expect(tokens[7]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

      {tokens} = grammar.tokenizeLine("s_text_test_acdegilmnoprsux")
      expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
      expect(tokens[1]).toEqual value: "_", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl"]
      expect(tokens[3]).toEqual value: "_", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[4]).toEqual value: "test", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl"]
      expect(tokens[5]).toEqual value: "_", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(tokens[6]).toEqual value: "acdegilmnoprsux", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

    it "works with two '/' delimiter in the first line, and one in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);/
        chr($1)
      /gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[0][8]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[2][0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[2][2]).toEqual value: ";", scopes: ["source.perl"]

    it "works with one '/' delimiter in the first line, one in the next and one in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);
      /
        chr($1)
      /gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replace.extended.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replace.extended.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[3][0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replace.extended.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[3][2]).toEqual value: ";", scopes: ["source.perl"]

    it "works with one '/' delimiter in the first line and two in the last", ->
      lines = grammar.tokenizeLines("""$line =~ s/&#(\\d+);
      /chr($1)/gxe;""")
      expect(lines[0][4]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replace.extended.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[1][0]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replace.extended.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[1][5]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replace.extended.simple_delimiter.perl", "punctuation.definition.string.perl"]
      expect(lines[1][7]).toEqual value: ";", scopes: ["source.perl"]

  describe "tokenizes constant variables", ->
    it "highlights constants", ->
      {tokens} = grammar.tokenizeLine("__FILE__")
      expect(tokens[0]).toEqual value: "__FILE__", scopes: ["source.perl", "constant.language.perl"]

      {tokens} = grammar.tokenizeLine("__LINE__")
      expect(tokens[0]).toEqual value: "__LINE__", scopes: ["source.perl", "constant.language.perl"]

      {tokens} = grammar.tokenizeLine("__PACKAGE__")
      expect(tokens[0]).toEqual value: "__PACKAGE__", scopes: ["source.perl", "constant.language.perl"]

      {tokens} = grammar.tokenizeLine("__SUB__")
      expect(tokens[0]).toEqual value: "__SUB__", scopes: ["source.perl", "constant.language.perl"]

      {tokens} = grammar.tokenizeLine("__END__")
      expect(tokens[0]).toEqual value: "__END__", scopes: ["source.perl", "constant.language.perl"]

      {tokens} = grammar.tokenizeLine("__DATA__")
      expect(tokens[0]).toEqual value: "__DATA__", scopes: ["source.perl", "constant.language.perl"]

    it "does highlight custom constants different", ->
      {tokens} = grammar.tokenizeLine("__TEST__")
      expect(tokens[0]).toEqual value: "__TEST__", scopes: ["source.perl", "string.unquoted.program-block.perl", "punctuation.definition.string.begin.perl"]

  describe "when an __END__ constant is used", ->
    it "highlights subsequent lines as comments", ->
      lines = grammar.tokenizeLines("""
      "String";
      __END__
      "String";
      """)
      expect(lines[2][0]).toEqual value: '"String";', scopes: ["source.perl", "comment.block.documentation.perl"]

  describe "tokenizes compile phase keywords", ->
    it "does highlight all compile phase keywords", ->
      {tokens} = grammar.tokenizeLine("BEGIN")
      expect(tokens[0]).toEqual value: "BEGIN", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]

      {tokens} = grammar.tokenizeLine("UNITCHECK")
      expect(tokens[0]).toEqual value: "UNITCHECK", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]

      {tokens} = grammar.tokenizeLine("CHECK")
      expect(tokens[0]).toEqual value: "CHECK", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]

      {tokens} = grammar.tokenizeLine("INIT")
      expect(tokens[0]).toEqual value: "INIT", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]

      {tokens} = grammar.tokenizeLine("END")
      expect(tokens[0]).toEqual value: "END", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]

      {tokens} = grammar.tokenizeLine("DESTROY")
      expect(tokens[0]).toEqual value: "DESTROY", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]

  describe "tokenizes method calls", ->
    it "does not highlight if called like a method", ->
      {tokens} = grammar.tokenizeLine("$test->q;")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.perl", "keyword.operator.comparison.perl"]
      expect(tokens[3]).toEqual value: "q;", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("$test->q();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.perl", "keyword.operator.comparison.perl"]
      expect(tokens[3]).toEqual value: "q();", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("$test->qq();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.perl", "keyword.operator.comparison.perl"]
      expect(tokens[3]).toEqual value: "qq();", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("$test->qw();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.perl", "keyword.operator.comparison.perl"]
      expect(tokens[3]).toEqual value: "qw();", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("$test->qx();")
      expect(tokens[2]).toEqual value: "->", scopes: ["source.perl", "keyword.operator.comparison.perl"]
      expect(tokens[3]).toEqual value: "qx();", scopes: ["source.perl"]

  describe "when a function call tokenizes", ->
    it "does not highlight calls which looks like a regexp", ->
      {tokens} = grammar.tokenizeLine("s_ttest($key,\"t_storage\",$single_task);")
      expect(tokens[0]).toEqual value: "s_ttest(", scopes: ["source.perl"]
      expect(tokens[3]).toEqual value: ",", scopes: ["source.perl"]
      expect(tokens[7]).toEqual value: ",", scopes: ["source.perl"]
      expect(tokens[10]).toEqual value: ");", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("s__ttest($key,\"t_license\",$single_task);")
      expect(tokens[0]).toEqual value: "s__ttest(", scopes: ["source.perl"]
      expect(tokens[3]).toEqual value: ",", scopes: ["source.perl"]
      expect(tokens[7]).toEqual value: ",", scopes: ["source.perl"]
      expect(tokens[10]).toEqual value: ");", scopes: ["source.perl"]

  describe "tokenizes single quoting", ->
    it "does not escape characters in single-quote strings", ->
      {tokens} = grammar.tokenizeLine("'Test this\\nsimple one';")
      expect(tokens[0]).toEqual value: "'", scopes: ["source.perl", "string.quoted.single.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Test this\\nsimple one", scopes: ["source.perl", "string.quoted.single.perl"]
      expect(tokens[2]).toEqual value: "'", scopes: ["source.perl", "string.quoted.single.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("q(Test this\\nsimple one);")
      expect(tokens[0]).toEqual value: "q(", scopes: ["source.perl", "string.quoted.other.q-paren.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Test this\\nsimple one", scopes: ["source.perl", "string.quoted.other.q-paren.perl"]
      expect(tokens[2]).toEqual value: ")", scopes: ["source.perl", "string.quoted.other.q-paren.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("q~Test this\\nadvanced one~;")
      expect(tokens[0]).toEqual value: "q~", scopes: ["source.perl", "string.quoted.other.q.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Test this\\nadvanced one", scopes: ["source.perl", "string.quoted.other.q.perl"]
      expect(tokens[2]).toEqual value: "~", scopes: ["source.perl", "string.quoted.other.q.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.perl"]

    it "does not escape characters in single-quote multiline strings", ->
      lines = grammar.tokenizeLines("""q(
      This is my first line\\n
      and this the second one\\x00
      last
      );""")
      expect(lines[0][0]).toEqual value: "q(", scopes: ["source.perl", "string.quoted.other.q-paren.perl", "punctuation.definition.string.begin.perl"]
      expect(lines[1][0]).toEqual value: "This is my first line\\n", scopes: ["source.perl", "string.quoted.other.q-paren.perl"]
      expect(lines[2][0]).toEqual value: "and this the second one\\x00", scopes: ["source.perl", "string.quoted.other.q-paren.perl"]
      expect(lines[3][0]).toEqual value: "last", scopes: ["source.perl", "string.quoted.other.q-paren.perl"]
      expect(lines[4][0]).toEqual value: ")", scopes: ["source.perl", "string.quoted.other.q-paren.perl", "punctuation.definition.string.end.perl"]
      expect(lines[4][1]).toEqual value: ";", scopes: ["source.perl"]

      lines = grammar.tokenizeLines("""q~
      This is my first line\\n
      and this the second one)\\x00
      last
      ~;""")
      expect(lines[0][0]).toEqual value: "q~", scopes: ["source.perl", "string.quoted.other.q.perl", "punctuation.definition.string.begin.perl"]
      expect(lines[1][0]).toEqual value: "This is my first line\\n", scopes: ["source.perl", "string.quoted.other.q.perl"]
      expect(lines[2][0]).toEqual value: "and this the second one)\\x00", scopes: ["source.perl", "string.quoted.other.q.perl"]
      expect(lines[3][0]).toEqual value: "last", scopes: ["source.perl", "string.quoted.other.q.perl"]
      expect(lines[4][0]).toEqual value: "~", scopes: ["source.perl", "string.quoted.other.q.perl", "punctuation.definition.string.end.perl"]
      expect(lines[4][1]).toEqual value: ";", scopes: ["source.perl"]

    it "does not highlight the whole word as an escape sequence", ->
      {tokens} = grammar.tokenizeLine("\"I l\\xF6ve th\\x{00E4}s\";")
      expect(tokens[0]).toEqual value: "\"", scopes: ["source.perl", "string.quoted.double.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "I l", scopes: ["source.perl", "string.quoted.double.perl"]
      expect(tokens[2]).toEqual value: "\\xF6", scopes: ["source.perl", "string.quoted.double.perl", "constant.character.escape.perl"]
      expect(tokens[3]).toEqual value: "ve th", scopes: ["source.perl", "string.quoted.double.perl"]
      expect(tokens[4]).toEqual value: "\\x{00E4}", scopes: ["source.perl", "string.quoted.double.perl", "constant.character.escape.perl"]
      expect(tokens[5]).toEqual value: "s", scopes: ["source.perl", "string.quoted.double.perl"]
      expect(tokens[6]).toEqual value: "\"", scopes: ["source.perl", "string.quoted.double.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.perl"]

  describe "tokenizes double quoting", ->
    it "does escape characters in double-quote strings", ->
      {tokens} = grammar.tokenizeLine("\"Test\\tthis\\nsimple one\";")
      expect(tokens[0]).toEqual value: "\"", scopes: ["source.perl", "string.quoted.double.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.perl", "string.quoted.double.perl"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.perl", "string.quoted.double.perl", "constant.character.escape.perl"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.perl", "string.quoted.double.perl"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.perl", "string.quoted.double.perl", "constant.character.escape.perl"]
      expect(tokens[5]).toEqual value: "simple one", scopes: ["source.perl", "string.quoted.double.perl"]
      expect(tokens[6]).toEqual value: "\"", scopes: ["source.perl", "string.quoted.double.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("qq(Test\\tthis\\nsimple one);")
      expect(tokens[0]).toEqual value: "qq(", scopes: ["source.perl", "string.quoted.other.qq-paren.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.perl", "string.quoted.other.qq-paren.perl"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.perl", "string.quoted.other.qq-paren.perl", "constant.character.escape.perl"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.perl", "string.quoted.other.qq-paren.perl"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.perl", "string.quoted.other.qq-paren.perl", "constant.character.escape.perl"]
      expect(tokens[5]).toEqual value: "simple one", scopes: ["source.perl", "string.quoted.other.qq-paren.perl"]
      expect(tokens[6]).toEqual value: ")", scopes: ["source.perl", "string.quoted.other.qq-paren.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.perl"]

      {tokens} = grammar.tokenizeLine("qq~Test\\tthis\\nadvanced one~;")
      expect(tokens[0]).toEqual value: "qq~", scopes: ["source.perl", "string.quoted.other.qq.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Test", scopes: ["source.perl", "string.quoted.other.qq.perl"]
      expect(tokens[2]).toEqual value: "\\t", scopes: ["source.perl", "string.quoted.other.qq.perl", "constant.character.escape.perl"]
      expect(tokens[3]).toEqual value: "this", scopes: ["source.perl", "string.quoted.other.qq.perl"]
      expect(tokens[4]).toEqual value: "\\n", scopes: ["source.perl", "string.quoted.other.qq.perl", "constant.character.escape.perl"]
      expect(tokens[5]).toEqual value: "advanced one", scopes: ["source.perl", "string.quoted.other.qq.perl"]
      expect(tokens[6]).toEqual value: "~", scopes: ["source.perl", "string.quoted.other.qq.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[7]).toEqual value: ";", scopes: ["source.perl"]

  describe "tokenizes word quoting", ->
    it "quotes words", ->
      {tokens} = grammar.tokenizeLine("qw(Aword Bword Cword);")
      expect(tokens[0]).toEqual value: "qw(", scopes: ["source.perl", "string.quoted.other.q-paren.perl", "punctuation.definition.string.begin.perl"]
      expect(tokens[1]).toEqual value: "Aword Bword Cword", scopes: ["source.perl", "string.quoted.other.q-paren.perl"]
      expect(tokens[2]).toEqual value: ")", scopes: ["source.perl", "string.quoted.other.q-paren.perl", "punctuation.definition.string.end.perl"]
      expect(tokens[3]).toEqual value: ";", scopes: ["source.perl"]

  describe "tokenizes subroutines", ->
    it "does highlight subroutines", ->
      lines = grammar.tokenizeLines("""sub mySub {
          print "asd";
      }""")
      expect(lines[0][0]).toEqual value: "sub", scopes: ["source.perl", "meta.function.perl", "storage.type.sub.perl"]
      expect(lines[0][2]).toEqual value: "mySub", scopes: ["source.perl", "meta.function.perl", "entity.name.function.perl"]
      expect(lines[0][4]).toEqual value: "{", scopes: ["source.perl"]
      expect(lines[2][0]).toEqual value: "}", scopes: ["source.perl"]

    it "does highlight subroutines assigned to a variable", ->
      lines = grammar.tokenizeLines("""my $test = sub {
          print "asd";
      };""")
      expect(lines[0][5]).toEqual value: "sub", scopes: ["source.perl", "meta.function.perl", "storage.type.sub.perl"]
      expect(lines[0][7]).toEqual value: "{", scopes: ["source.perl"]
      expect(lines[2][0]).toEqual value: "};", scopes: ["source.perl"]

    it "does highlight subroutines assigned to a hash key", ->
      lines = grammar.tokenizeLines("""my $test = { a => sub {
          print "asd";
      }};""")
      expect(lines[0][9]).toEqual value: "sub", scopes: ["source.perl", "meta.function.perl", "storage.type.sub.perl"]
      expect(lines[0][11]).toEqual value: "{", scopes: ["source.perl"]
      expect(lines[2][0]).toEqual value: "}};", scopes: ["source.perl"]

  describe "tokenizes format", ->
    it "works as expected", ->
      lines = grammar.tokenizeLines("""format STDOUT_TOP =
                     Passwd File
Name                Login    Office   Uid   Gid Home
------------------------------------------------------------------
.
format STDOUT =
@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<
$name,              $login,  $office,$uid,$gid, $home
.""")
      expect(lines[0][0]).toEqual value: "format", scopes: ["source.perl", "meta.format.perl", "support.function.perl"]
      expect(lines[0][2]).toEqual value: "STDOUT_TOP", scopes: ["source.perl", "meta.format.perl", "entity.name.function.format.perl"]
      expect(lines[1][0]).toEqual value: "Passwd File", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[2][0]).toEqual value: "Name                Login    Office   Uid   Gid Home", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[3][0]).toEqual value: "------------------------------------------------------------------", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[4][0]).toEqual value: ".", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[5][0]).toEqual value: "format", scopes: ["source.perl", "meta.format.perl", "support.function.perl"]
      expect(lines[5][2]).toEqual value: "STDOUT", scopes: ["source.perl", "meta.format.perl", "entity.name.function.format.perl"]
      expect(lines[6][0]).toEqual value: "@<<<<<<<<<<<<<<<<<< @||||||| @<<<<<<@>>>> @>>>> @<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[8][0]).toEqual value: ".", scopes: ["source.perl", "meta.format.perl"]

      lines = grammar.tokenizeLines("""format STDOUT_TOP =
                         Bug Reports
@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>
$system,                      $%,         $date
------------------------------------------------------------------
.
format STDOUT =
Subject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      $subject
Index: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    $index,                       $description
Priority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
       $priority,        $date,   $description
From: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
   $from,                         $description
Assigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          $programmer,            $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                  $description
~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...
                                  $description
.""")
      expect(lines[0][0]).toEqual value: "format", scopes: ["source.perl", "meta.format.perl", "support.function.perl"]
      expect(lines[0][2]).toEqual value: "STDOUT_TOP", scopes: ["source.perl", "meta.format.perl", "entity.name.function.format.perl"]
      expect(lines[2][0]).toEqual value: "@<<<<<<<<<<<<<<<<<<<<<<<     @|||         @>>>>>>>>>>>>>>>>>>>>>>>", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[4][0]).toEqual value: "------------------------------------------------------------------", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[5][0]).toEqual value: ".", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[6][0]).toEqual value: "format", scopes: ["source.perl", "meta.format.perl", "support.function.perl"]
      expect(lines[6][2]).toEqual value: "STDOUT", scopes: ["source.perl", "meta.format.perl", "entity.name.function.format.perl"]
      expect(lines[7][0]).toEqual value: "Subject: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[9][0]).toEqual value: "Index: @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[11][0]).toEqual value: "Priority: @<<<<<<<<<< Date: @<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[13][0]).toEqual value: "From: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[15][0]).toEqual value: "Assigned to: @<<<<<<<<<<<<<<<<<<<<<< ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[17][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[19][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[21][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[23][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[25][0]).toEqual value: "~                                    ^<<<<<<<<<<<<<<<<<<<<<<<...", scopes: ["source.perl", "meta.format.perl"]
      expect(lines[27][0]).toEqual value: ".", scopes: ["source.perl", "meta.format.perl"]

  describe "when a heredoc tokenizes", ->
    it "does not highlight the whole line", ->
      lines = grammar.tokenizeLines("""$asd->foo(<<TEST, $bar, s/foo/bar/g);
asd
TEST
;""")
      expect(lines[0][4]).toEqual value: "<<", scopes: ["source.perl", "punctuation.definition.string.perl", "string.unquoted.heredoc.perl", "punctuation.definition.heredoc.perl"]
      expect(lines[0][5]).toEqual value: "TEST", scopes: ["source.perl", "punctuation.definition.string.perl", "string.unquoted.heredoc.perl"]
      expect(lines[0][6]).toEqual value: ", ", scopes: ["source.perl"]
      expect(lines[3][0]).toEqual value: ";", scopes: ["source.perl"]

    it "does not highlight variables and escape sequences in a single quote heredoc", ->
      lines = grammar.tokenizeLines("""$asd->foo(<<'TEST');
$asd\\n
;""")
      expect(lines[1][0]).toEqual value: "$asd\\n", scopes: ["source.perl", "string.unquoted.heredoc.quote.perl"]

      lines = grammar.tokenizeLines("""$asd->foo(<<\\TEST);
$asd\\n
;""")
      expect(lines[1][0]).toEqual value: "$asd\\n", scopes: ["source.perl", "string.unquoted.heredoc.quote.perl"]

  describe "when a hash variable tokenizes", ->
    it "does not highlight whitespace beside a key as a constant", ->
      lines = grammar.tokenizeLines("""my %hash = (
  key => 'value1',
  'key' => 'value2'
);""")
      expect(lines[1][0]).toEqual value: "key", scopes: ["source.perl", "constant.other.key.perl"]
      expect(lines[1][1]).toEqual value: " ", scopes: ["source.perl"]
      expect(lines[2][0]).toEqual value: "'", scopes: ["source.perl", "string.quoted.single.perl", "punctuation.definition.string.begin.perl"]
      expect(lines[2][1]).toEqual value: "key", scopes: ["source.perl", "string.quoted.single.perl"]
      expect(lines[2][2]).toEqual value: "'", scopes: ["source.perl", "string.quoted.single.perl", "punctuation.definition.string.end.perl"]
      expect(lines[2][3]).toEqual value: " ", scopes: ["source.perl"]

  describe "when a variable tokenizes", ->
    it "highlights its type separately", ->
      lines = grammar.tokenizeLines("""my $scalar;
      $scalar
      @array
      %hash
      my $array_ref = \\@array;
      my $hash_ref = \\%hash;
      my @array = @$array_ref;
      my %hash = %$hash_ref;
      my @n = sort {$a <=> $b} @m;
      """)
      expect(lines[0][2]).toEqual value: "$", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[0][3]).toEqual value: "scalar", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[1][0]).toEqual value: "$", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[1][1]).toEqual value: "scalar", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[2][0]).toEqual value: "@", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[2][1]).toEqual value: "array", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[3][0]).toEqual value: "%", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[3][1]).toEqual value: "hash", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[4][2]).toEqual value: "$", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[4][3]).toEqual value: "array_ref", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[4][5]).toEqual value: "\\@", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[4][6]).toEqual value: "array", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[5][2]).toEqual value: "$", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[5][3]).toEqual value: "hash_ref", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[5][5]).toEqual value: "\\%", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[5][6]).toEqual value: "hash", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[6][2]).toEqual value: "@", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[6][3]).toEqual value: "array", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[6][5]).toEqual value: "@$", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[6][6]).toEqual value: "array_ref", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[7][2]).toEqual value: "%", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[7][3]).toEqual value: "hash", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[7][5]).toEqual value: "%$", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[7][6]).toEqual value: "hash_ref", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[8][2]).toEqual value: "@", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[8][3]).toEqual value: "n", scopes: ["source.perl", "variable.other.readwrite.global.perl"]
      expect(lines[8][7]).toEqual value: "$", scopes: ["source.perl", "variable.other.predefined.perl", "punctuation.definition.variable.perl"]
      expect(lines[8][8]).toEqual value: "a", scopes: ["source.perl", "variable.other.predefined.perl"]
      expect(lines[8][12]).toEqual value: "$", scopes: ["source.perl", "variable.other.predefined.perl", "punctuation.definition.variable.perl"]
      expect(lines[8][13]).toEqual value: "b", scopes: ["source.perl", "variable.other.predefined.perl"]
      expect(lines[8][15]).toEqual value: "@", scopes: ["source.perl", "variable.other.readwrite.global.perl", "punctuation.definition.variable.perl"]
      expect(lines[8][16]).toEqual value: "m", scopes: ["source.perl", "variable.other.readwrite.global.perl"]

  describe "when package to tokenizes", ->
    it "does not highlight semicolon in package name", ->
      {tokens} = grammar.tokenizeLine("package Test::ASD; #this is my new class")
      expect(tokens[0]).toEqual value: "package", scopes: ["source.perl", "meta.class.perl", "keyword.control.perl"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.perl", "meta.class.perl"]
      expect(tokens[2]).toEqual value: "Test::ASD", scopes: ["source.perl", "meta.class.perl", "entity.name.type.class.perl"]
      expect(tokens[3]).toEqual value: "; ", scopes: ["source.perl"]
      expect(tokens[4]).toEqual value: "#", scopes: ["source.perl", "comment.line.number-sign.perl", "punctuation.definition.comment.perl"]
      expect(tokens[5]).toEqual value: "this is my new class", scopes: ["source.perl", "comment.line.number-sign.perl"]

  describe "when tokenising Pod markup", ->
    it "highlights Pod commands", ->
      lines = grammar.tokenizeLines """
        =pod
        Bar
        =cut
      """
      expect(lines[0][0]).toEqual value: "=pod", scopes: ["source.perl", "comment.block.documentation.perl", "storage.type.class.pod.perl"]
      expect(lines[1][0]).toEqual value: "Bar", scopes: ["source.perl", "comment.block.documentation.perl"]
      expect(lines[2][0]).toEqual value: "=cut", scopes: ["source.perl", "comment.block.documentation.perl", "storage.type.class.pod.perl"]

    it "does not highlight commands with leading whitespace", ->
      {tokens} = grammar.tokenizeLine(" =pod")
      expect(tokens[0]).toEqual value: " =pod", scopes: ["source.perl"]

    it "highlights additional command parameters", ->
      {tokens} = grammar.tokenizeLine("=head1 Heading")
      expect(tokens[0]).toEqual value: "=head1", scopes: ["source.perl", "comment.block.documentation.perl", "storage.type.class.pod.perl"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.perl", "comment.block.documentation.perl"]
      expect(tokens[2]).toEqual value: "Heading", scopes: ["source.perl", "comment.block.documentation.perl", "variable.other.pod.perl"]

    it "highlights formatting codes", ->
      lines = grammar.tokenizeLines """
        =pod
        See L<perlpod(1)>.
      """
      expect(lines[1][0]).toEqual value: "See ", scopes: ["source.perl", "comment.block.documentation.perl"]
      expect(lines[1][1]).toEqual value: "L<", scopes: ["source.perl", "comment.block.documentation.perl", "entity.name.type.instance.pod.perl"]
      expect(lines[1][2]).toEqual value: "perlpod(1)", scopes: ["source.perl", "comment.block.documentation.perl", "entity.name.type.instance.pod.perl", "markup.underline.link.hyperlink.pod.perl"]
      expect(lines[1][3]).toEqual value: ">", scopes: ["source.perl", "comment.block.documentation.perl", "entity.name.type.instance.pod.perl"]

    it "highlights formatting codes in command parameters", ->
      {tokens} = grammar.tokenizeLine("=head1 This is a B<bold heading>")
      expect(tokens[2]).toEqual value: "This is a ", scopes: ["source.perl", "comment.block.documentation.perl", "variable.other.pod.perl"]
      expect(tokens[3]).toEqual value: "B<", scopes: ["source.perl", "comment.block.documentation.perl", "variable.other.pod.perl", "entity.name.type.instance.pod.perl"]
      expect(tokens[4]).toEqual value: "bold heading", scopes: ["source.perl", "comment.block.documentation.perl", "variable.other.pod.perl", "entity.name.type.instance.pod.perl", "markup.bold.pod.perl"]
      expect(tokens[5]).toEqual value: ">", scopes: ["source.perl", "comment.block.documentation.perl", "variable.other.pod.perl", "entity.name.type.instance.pod.perl"]

    it "highlights multiple angle-brackets correctly in formatting codes", ->
      lines = grammar.tokenizeLines """
        =pod
        Text I<< <italic> >> Text
      """
      expect(lines[1][0]).toEqual value: "Text ", scopes: ["source.perl", "comment.block.documentation.perl"]
      expect(lines[1][1]).toEqual value: "I<<", scopes: ["source.perl", "comment.block.documentation.perl", "entity.name.type.instance.pod.perl"]
      expect(lines[1][2]).toEqual value: " <italic> ", scopes: ["source.perl", "comment.block.documentation.perl", "entity.name.type.instance.pod.perl", "markup.italic.pod.perl"]
      expect(lines[1][3]).toEqual value: ">>", scopes: ["source.perl", "comment.block.documentation.perl", "entity.name.type.instance.pod.perl"]
      expect(lines[1][4]).toEqual value: " Text", scopes: ["source.perl", "comment.block.documentation.perl"]

    it "uses HTML highlighting in embedded HTML snippets", ->
      lines = grammar.tokenizeLines """
        =pod
        =begin html
        <b>Bold</b>
        =end html
      """
      expect(lines[1][0]).toEqual value: "=begin", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl", "storage.type.class.pod.perl"]
      expect(lines[1][1]).toEqual value: " ", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl"]
      expect(lines[1][2]).toEqual value: "html", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl", "variable.other.pod.perl"]
      expect(lines[2][0]).toEqual value: "<b>Bold</b>", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl", "text.embedded.html.basic"]
      expect(lines[3][0]).toEqual value: "=end", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl", "storage.type.class.pod.perl"]
      expect(lines[3][1]).toEqual value: " ", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl"]
      expect(lines[3][2]).toEqual value: "html", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl", "variable.other.pod.perl"]

    it "cuts embedded snippets off early before a terminating =cut command", ->
      lines = grammar.tokenizeLines """
        =pod
        =begin html
        <b>Bold</b>
        =cut
        my $var;
      """
      expect(lines[2][0]).toEqual value: "<b>Bold</b>", scopes: ["source.perl", "comment.block.documentation.perl", "meta.embedded.pod.perl", "text.embedded.html.basic"]
      expect(lines[3][0]).toEqual value: "=cut", scopes: ["source.perl", "comment.block.documentation.perl", "storage.type.class.pod.perl"]
      expect(lines[4][0]).toEqual value: "my", scopes: ["source.perl", "storage.modifier.perl"]

  describe "firstLineMatch", ->
    it "recognises interpreter directives", ->
      valid = """
        #!perl -w
        #! perl -w
        #!/usr/sbin/perl foo
        #!/usr/bin/perl foo=bar/
        #!/usr/sbin/perl
        #!/usr/sbin/perl foo bar baz
        #!/usr/bin/env perl
        #!/usr/bin/env bin/perl
        #!/usr/bin/perl
        #!/bin/perl
        #!/usr/bin/perl --script=usr/bin
        #! /usr/bin/env A=003 B=149 C=150 D=xzd E=base64 F=tar G=gz H=head I=tail perl
        #!\t/usr/bin/env --foo=bar perl --quu=quux
        #! /usr/bin/perl
        #!/usr/bin/env perl
      """
      for line in valid.split /\n/
        expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()

      invalid = """
        #! pearl
        #!=perl
        perl
        #perl
        \x20#!/usr/sbin/perl
        \t#!/usr/sbin/perl
        #!
        #!\x20
        #!/usr/bin/env-perl/perl-env/
        #!/usr/bin/env-perl
        #! /usr/binperl
        #!\t/usr/bin/env --perl=bar
      """
      for line in invalid.split /\n/
        expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).toBeNull()

    it "recognises Emacs modelines", ->
      valid = """
        #-*-perl-*-
        #-*-mode:perl-*-
        /* -*-perl-*- */
        // -*- PERL -*-
        /* -*- mode:perl -*- */
        // -*- font:bar;mode:Perl -*-
        // -*- font:bar;mode:Perl;foo:bar; -*-
        // -*-font:mode;mode:perl-*-
        " -*-foo:bar;mode:Perl;bar:foo-*- ";
        " -*-font-mode:foo;mode:Perl;foo-bar:quux-*-"
        "-*-font:x;foo:bar; mode : pErL;bar:foo;foooooo:baaaaar;fo:ba;-*-";
        "-*- font:x;foo : bar ; mode : pErL ; bar : foo ; foooooo:baaaaar;fo:ba-*-";
      """
      for line in valid.split /\n/
        expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()

      invalid = """
        /* --*perl-*- */
        /* -*-- perl -*-
        /* -*- -- perl -*-
        /* -*- perl -;- -*-
        // -*- iPERL -*-
        // -*- perl-stuff -*-
        /* -*- model:perl -*-
        /* -*- indent-mode:perl -*-
        // -*- font:mode;Perl -*-
        // -*- mode: -*- Perl
        // -*- mode: grok-with-perl -*-
        // -*-font:mode;mode:perl--*-
      """
      for line in invalid.split /\n/
        expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).toBeNull()

    it "recognises Vim modelines", ->
      valid = """
        vim: se filetype=perl:
        # vim: se ft=perl:
        # vim: set ft=perl:
        # vim: set filetype=Perl:
        # vim: ft=perl
        # vim: syntax=pERl
        # vim: se syntax=PERL:
        # ex: syntax=perl
        # vim:ft=perl
        # vim600: ft=perl
        # vim>600: set ft=perl:
        # vi:noai:sw=3 ts=6 ft=perl
        # vi::::::::::noai:::::::::::: ft=perl
        # vim:ts=4:sts=4:sw=4:noexpandtab:ft=perl
        # vi:: noai : : : : sw   =3 ts   =6 ft  =perl
        # vim: ts=4: pi sts=4: ft=perl: noexpandtab: sw=4:
        # vim: ts=4 sts=4: ft=perl noexpandtab:
        # vim:noexpandtab sts=4 ft=perl ts=4
        # vim:noexpandtab:ft=perl
        # vim:ts=4:sts=4 ft=perl:noexpandtab:\x20
        # vim:noexpandtab titlestring=hi\|there\\\\ ft=perl ts=4
      """
      for line in valid.split /\n/
        expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()

      invalid = """
        ex: se filetype=perl:
        _vi: se filetype=perl:
         vi: se filetype=perl
        # vim set ft=perlo
        # vim: soft=perl
        # vim: hairy-syntax=perl:
        # vim set ft=perl:
        # vim: setft=perl:
        # vim: se ft=perl backupdir=tmp
        # vim: set ft=perl set cmdheight=1
        # vim:noexpandtab sts:4 ft:perl ts:4
        # vim:noexpandtab titlestring=hi\\|there\\ ft=perl ts=4
        # vim:noexpandtab titlestring=hi\\|there\\\\\\ ft=perl ts=4
      """
      for line in invalid.split /\n/
        expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).toBeNull()
