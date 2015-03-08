describe "perl grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl"

  it "tokenizes regexp replace", ->
    {tokens} = grammar.tokenizeLine("s/text/test/")
    expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
    expect(tokens[1]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl"]
    expect(tokens[3]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[4]).toEqual value: "test", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl"]
    expect(tokens[5]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]

    {tokens} = grammar.tokenizeLine("s_text_test_")
    expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
    expect(tokens[1]).toEqual value: "_", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl"]
    expect(tokens[3]).toEqual value: "_", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[4]).toEqual value: "test", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl"]
    expect(tokens[5]).toEqual value: "_", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]

    {tokens} = grammar.tokenizeLine("s/text/test/gxr")
    expect(tokens[0]).toEqual value: "s", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl", "support.function.perl"]
    expect(tokens[1]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[2]).toEqual value: "text", scopes: ["source.perl", "string.regexp.replaceXXX.simple_delimiter.perl"]
    expect(tokens[3]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[4]).toEqual value: "test", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl"]
    expect(tokens[5]).toEqual value: "/", scopes: ["source.perl", "string.regexp.replaceXXX.format.simple_delimiter.perl", "punctuation.definition.string.perl"]
    expect(tokens[6]).toEqual value: "gxr", scopes: ["source.perl", "string.regexp.replace.perl", "punctuation.definition.string.perl", "keyword.control.regexp-option.perl"]

  it "tokenizes constant variables", ->
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