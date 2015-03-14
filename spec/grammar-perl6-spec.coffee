describe "Perl 6 grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl6")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl6"

  describe "identifiers", ->
    it "should match simple scalar identifiers", ->
      {tokens} = grammar.tokenizeLine('$a')
      expect(tokens[0]).toEqual value: '$a', scopes: ['source.perl6', 'variable.other.scalar.perl6']

    it "should match simple array identifiers", ->
      {tokens} = grammar.tokenizeLine('@a')
      expect(tokens[0]).toEqual value: '@a', scopes: ['source.perl6', 'variable.other.array.perl6']

    it "should match simple hash identifiers", ->
      {tokens} = grammar.tokenizeLine('%a')
      expect(tokens[0]).toEqual value: '%a', scopes: ['source.perl6', 'variable.other.hash.perl6']

    it "should match simple hash identifiers", ->
      {tokens} = grammar.tokenizeLine('&a')
      expect(tokens[0]).toEqual value: '&a', scopes: ['source.perl6', 'variable.other.code.perl6']

  describe "strings", ->
    it "should tokenize simple strings", ->
      {tokens} = grammar.tokenizeLine('"abc"')
      expect(tokens.length).toEqual 3
      expect(tokens[0]).toEqual value: '"', scopes: ['source.perl6', 'string.quoted.double.perl6', 'punctuation.definition.string.begin.perl6']
      expect(tokens[1]).toEqual value: 'abc', scopes: ['source.perl6', 'string.quoted.double.perl6']
      expect(tokens[2]).toEqual value: '"', scopes: ['source.perl6', 'string.quoted.double.perl6', 'punctuation.definition.string.end.perl6']

  describe "modules", ->
    it "should parse package declarations", ->
      {tokens} = grammar.tokenizeLine("class Johnny's::Super-Cool::Module")
      expect(tokens.length).toEqual 3
  describe "comments", ->
    it "should parse comments", ->
      {tokens} = grammar.tokenizeLine("# this is the comment")
      expect(tokens.length).toEqual 3
      expect(tokens[0]).toEqual
        value: '#'
        scopes: [
          'source.perl6'
          'comment.line.number-sign.perl6'
          'punctuation.definition.comment.perl6'
        ]
      expect(tokens[1]).toEqual
        value: ' this is the comment',
        scopes: [
          'source.perl6'
          'comment.line.number-sign.perl6'
        ]
