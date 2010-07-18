require File.expand_path File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Lang::Tag, "'de-DE'" do

  before :each do
    @langtag = Lang::Tag('de-DE')
  end

  it "is equal to the langtag 'de-DE'" do
    @langtag.should == Lang::Tag('de-DE')
  end

  it "is not equal to the string 'de-DE'" do
    @langtag.should_not == 'de-DE'
  end

  it "is equal to the langtag 'DE-de'" do
    @langtag.should == Lang::Tag('DE-de')
  end

  it "is equal to the langtag 'dE-De'" do
    @langtag.should == Lang::Tag('dE-De')
  end

  it "is not equal to the langtag 'de-DE-x-goethe'" do
    @langtag.should_not == Lang::Tag('de-DE-x-goethe')
  end

  it "is not equal to the langtag 'De-Latn-DE'" do
    @langtag.should_not == Lang::Tag('de-Latn-DE')
  end

  it "is not equal to the langtag 'de'" do
    @langtag.should_not == Lang::Tag('de')
  end

  it "is an equivalent of the 'de-DE'" do
    @langtag.should === Lang::Tag('DE-de')
    @langtag.should === 'DE-de'
  end

  it "is an equivalent of the 'dE-De'" do
    @langtag.should === Lang::Tag('dE-De')
    @langtag.should === 'dE-De'
  end

  it "is not an equivalent of the 'dE-De'" do
    @langtag.should_not === Lang::Tag('de-DE-x-goethe')
    @langtag.should_not === 'de-DE-x-goethe'
  end

  it "is not an equivalent of the 'de-DE-x-goethe'" do
    @langtag.should_not === Lang::Tag('de-DE-x-goethe')
    @langtag.should_not === 'de-DE-x-goethe'
  end

  it "is not an equivalent of 'de-Latn-DE'" do
    @langtag.should_not === Lang::Tag('de-Latn-DE')
    @langtag.should_not === 'de-Latn-DE'
  end

  it "is not an equivalent of the 'de'" do
    @langtag.should_not === Lang::Tag('de')
    @langtag.should_not === 'de'
  end

  it "is exactly equal to the langtag 'de-DE'" do
    @langtag.should be_eql Lang::Tag('de-DE')
  end

  it "has a same hash as a langtag 'de-DE'" do
    @langtag.hash.should == Lang::Tag('de-DE').hash
  end

  it "is not exactly equal to the langtag 'dE-De'" do
    @langtag.should_not be_eql Lang::Tag('dE-De')
  end

  it "is definitely not a 42" do
    @langtag.should_not ==  42
    @langtag.should_not === 42
    @langtag.should_not be_eql 42
  end

end

# language
describe Lang::Tag, "'jsl'" do

  before :each do
    @langtag = Lang::Tag('jsl')
  end

  it "has a language 'jsl'" do
    @langtag.language.should == 'jsl'
  end

  it "has a primary subtag 'jsl' (Japanese Sign Language)" do
    @langtag.primary.should == 'jsl'
  end

  it "has no extlang (canonical form)" do
    @langtag.extlang.should == nil
  end

  it "exposes a language in a composition" do
    @langtag.composition.should == 'jsl'
    @langtag.tag.should == 'jsl'
  end

  it "exposes a language when inspected" do
    @langtag.inspect.should =~ %r{jsl}
  end

  describe "when assigns the 'sgn-jsl' sequence to the language" do

    before :each do
      @langtag.language = "sgn-jsl"
    end

    it "assigns a language to the 'sgn-jsl'" do
      @langtag.language.should == 'sgn-jsl'
    end

    it "assigns a primary subtag to the 'sgn' (Sign Language)" do
      @langtag.primary.should == 'sgn'
    end

    it "assigns an extlang to the 'jsl'" do
      @langtag.extlang.should == 'jsl'
    end

    it "exposes a new language in a composition" do
      @langtag.composition.should == 'sgn-jsl'
      @langtag.tag.should == 'sgn-jsl'
    end

    it "exposes a new language when inspected" do
      @langtag.inspect.should =~ %r{sgn-jsl}
    end

  end

  describe "when assigns nil to the language" do
    it "raises an InvalidComponentError (primary subtag cannot be omitted)" do
      lambda { @langtag.language = nil
        }.should raise_error Lang::Tag::InvalidComponentError, %r{Primary subtag cannot be omitted}
    end
  end

  describe "when assigns the 'ill-formed' sequence to the language" do
    it "raises an InvalidComponentError (ill-formed sequence)" do
      lambda { @langtag.language = 'ill-formed'
        }.should raise_error Lang::Tag::InvalidComponentError, %r{"ill-formed" does not conform to the 'language' ABNF}
    end
  end

end

# script
describe Lang::Tag, "'zh-Hans'" do

  before :each do
    @langtag = Lang::Tag('zh-Hans')
  end

  it "has a script 'Hans' (Hangul simplified)" do
    @langtag.script.should == 'Hans'
  end

  it "exposes a script in a composition" do
    @langtag.composition.should == 'zh-hans'
    @langtag.tag.should == 'zh-Hans'
  end

  it "exposes a script when inspected" do
    @langtag.inspect.should =~ %r{zh-Hans}
  end

  describe "when assigns a 'Hant' to the script" do

    before :each do
      @langtag.script = 'Hant'
    end

    it "has a script 'Hant' (Hangul traditional)" do
      @langtag.script.should == 'Hant'
    end

    it "exposes a new script in a composition" do
      @langtag.composition.should == 'zh-hant'
      @langtag.tag.should == 'zh-Hant'
    end

    it "exposes a new script when inspected" do
      @langtag.inspect.should =~ %r{zh-Hant}
    end

  end

  describe "when assigns nil to the script" do

    before :each do
      @langtag.script = nil
    end

    it "has no script" do
      @langtag.script.should be_nil
    end

    it "removes an old script from a composition" do
      @langtag.composition.should == 'zh'
      @langtag.tag.should == 'zh'
    end

    it "does not expose a script when inspected" do
      @langtag.inspect.should =~ %r{zh}
    end

  end

  describe "when assigns the 'ill-formed' sequence to the script" do
    it "raises an InvalidComponentError (ill-formed sequence)" do
      lambda {
        @langtag.script = 'ill-formed'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{"ill-formed" does not conform to the 'script' ABNF}
    end
  end

end

# region
describe Lang::Tag, "'es-ES'" do

  before :each do
    @langtag = Lang::Tag('es-ES')
  end

  it "has a region 'ES' (Spain)" do
    @langtag.region.should == 'ES'
  end

  it "exposes a region in a composition" do
    @langtag.composition.should == 'es-es'
    @langtag.tag.should == 'es-ES'
  end

  it "exposes a region when inspected" do
    @langtag.inspect.should =~ %r{es-ES}
  end

  describe "when assigns a '419' to the region" do

    before :each do
      @langtag.region = '419'
    end

    it "has a region '419' (Spanish appropriate to the UN-defined Latin America and Caribbean region)" do
      @langtag.region.should == '419'
    end

    it "exposes a new region in a composition" do
      @langtag.composition.should == 'es-419'
      @langtag.tag.should == 'es-419'
    end

    it "exposes a new region when inspected" do
      @langtag.inspect.should =~ %r{es-419}
    end

  end

  describe "when assigns nil to the region" do

    before :each do
      @langtag.region = nil
    end

    it "has no region" do
      @langtag.region.should be_nil
    end

    it "removes an old region from a composition" do
      @langtag.composition.should == 'es'
      @langtag.tag.should == 'es'
    end

    it "does not expose a region when inspected" do
      @langtag.inspect.should =~ %r{es}
    end

  end

  describe "when assigns the 'ill-formed' sequence to the region" do
    it "raises an InvalidComponentError (ill-formed sequence)" do
      lambda {
        @langtag.region = 'ill-formed'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{"ill-formed" does not conform to the 'region' ABNF}
    end
  end

end

# variants
describe Lang::Tag, "'sl-rozaj-biske-1994'" do

  before :each do
    @langtag = Lang::Tag('sl-rozaj-biske-1994')
  end

  it "has a variant 'rozaj' (Resian, Resianic, Rezijan)" do
    @langtag.should have_variant 'rozaj'
  end

  it "has a variant 'ROZAJ', which is equal to 'rozaj'" do
    @langtag.should have_variant 'ROZAJ'
  end

  it "has a variant '1994' (Standardized Resian orthography)" do
    @langtag.should have_variant '1994'
  end

  it "has a variant 'biske' (San Giorgio/Bila dialect of Resian)" do
    @langtag.should have_variant 'biske'
  end

  it "has no variant 'nedis'" do
    @langtag.should_not have_variant 'nedis'
  end

  it "exposes a sequence of variants" do
    @langtag.variants_sequence.should == 'rozaj-biske-1994'
  end

  it "exposes variants as an Array" do
    @langtag.variants.should be_an_instance_of ::Array
    @langtag.variants.size.should == 3
    @langtag.variants.should == ['rozaj', 'biske', '1994']
  end

  it "exposes a sequence of variants in a composition" do
    @langtag.tag.should == 'sl-rozaj-biske-1994'
    @langtag.composition.should == 'sl-rozaj-biske-1994'
  end

  it "exposes a sequence of variants when inspected" do
    @langtag.inspect.should =~ %r{sl-rozaj-biske-1994}
  end

  describe "when assigns the 'Rozaj-nEDIS' sequence to variants" do

    before :each do
      @langtag.variants_sequence = 'Rozaj-nEDIS'
    end

    it "has a variant 'rozaj'" do
      @langtag.should have_variant 'rozaj'
    end

    it "has a variant 'nedis'" do
      @langtag.should have_variant 'nedis'
    end

    it "has a variant 'NeDiS', which is equal to 'nedis'" do
      @langtag.should have_variant 'NeDiS'
    end

    it "has no variant 'biske'" do
      @langtag.should_not have_variant 'biske'
    end

    it "has no variant '1994'" do
      @langtag.should_not have_variant 'biske'
    end

    it "exposes a new sequence of variants" do
      @langtag.variants_sequence.should == 'Rozaj-nEDIS'
    end

    it "exposes new variants as an Array" do
      @langtag.variants.should be_an_instance_of ::Array
      @langtag.variants.size.should == 2
      @langtag.variants.should == ['Rozaj', 'nEDIS']
    end

    it "exposes a new sequence of variants in a composition" do
      @langtag.tag.should == 'sl-Rozaj-nEDIS'
      @langtag.composition.should == 'sl-rozaj-nedis'
    end

    it "exposes a new sequence of variants when inspected" do
      @langtag.inspect.should =~ %r{sl-Rozaj-nEDIS}
    end

  end

  describe "when assigns nil to the variants" do

    it "assigns variants to nil" do
      @langtag.variants_sequence = nil
      @langtag.variants_sequence.should be_nil
      @langtag.variants.should be_nil
    end

    it "removes an old sequence of variants from a composition" do
      @langtag.variants_sequence = nil
      @langtag.composition.should == 'sl'
    end

    it "does not expose a sequence of variants when inspected" do
      @langtag.inspect.should =~ %r{sl}
    end

  end

  describe "when assigns the 'rozaj-biske-rozaj-biske' sequence to the variants" do
    it "raises an InvalidComponentError (repeated variants)" do
      lambda {
        @langtag.variants_sequence = 'rozaj-biske-rozaj-biske'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{repeated variants}
    end
  end

  describe "when assigns the 'Rozaj-Biske-rozaj-biske' sequence to the variants" do
    it "raises an InvalidComponentError (repeated variants)" do
      lambda {
        @langtag.variants_sequence = 'Rozaj-Biske-rozaj-biske'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{repeated variants}
    end
  end

  describe "when assigns the 'ill-formed' sequence to the variants" do
    it "raises an InvalidComponentError (ill-formed sequence)" do
      lambda {
        @langtag.variants_sequence = 'ill-formed'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{"ill-formed" does not conform to the 'variants' ABNF}
    end

  end

end

# extensions
describe Lang::Tag, "'ja-Latn-hepburn-p-hyphen-v-macron-colon'" do

  before :each do
    @langtag = Lang::Tag('ja-Latn-hepburn-p-hyphen-v-macron-colon')
  end

  it "has a 'p' singleton" do
    @langtag.should have_singleton('p')
    @langtag.should have_singleton('P')
  end

  it "exposes a 'p' extension as an Array" do
    @langtag.extension('p').should be_an_instance_of ::Array
    @langtag.extension('p').size.should == 1
    @langtag.extension('p').should == ['hyphen'] # hyphenated particles
    @langtag.extension('P').should == ['hyphen']
  end

  it "has a 'v' singleton" do
    @langtag.should have_singleton('v')
    @langtag.should have_singleton('V')
  end

  it "exposes a 'v' extension as an Array" do
    @langtag.extension('v').should be_an_instance_of ::Array
    @langtag.extension('v').size.should == 2
    @langtag.extension('v').should == ['macron', 'colon'] # indicate long vowels with macrons or colons
    @langtag.extension('V').should == ['macron', 'colon']
  end

  it "exposes a sequence of extensions" do
    @langtag.extensions_sequence.should == 'p-hyphen-v-macron-colon'
  end

  it "exposes a list of singletons" do
    @langtag.singletons.should be_an_instance_of ::Array
    @langtag.singletons.should == ['p', 'v']
  end

  it "has no a 'c' singleton" do
    @langtag.should_not have_singleton('c')
    @langtag.should_not have_singleton('C')
    @langtag.extension('c').should be_nil
  end

  it "exposes a sequence of extensions in a composition" do
    @langtag.composition.should == 'ja-latn-hepburn-p-hyphen-v-macron-colon'
    @langtag.tag.should == 'ja-Latn-hepburn-p-hyphen-v-macron-colon'
  end

  it "exposes a sequence of extensions when inspected" do
    @langtag.inspect.should =~ %r{ja-Latn-hepburn-p-hyphen-v-macron-colon}
  end

  describe "when assigns the 'ill-formed' sequence to the extensions" do
    it "raises an InvalidComponentError (ill-formed sequence)" do
      lambda {
        @langtag.extensions_sequence = 'ill-formed'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{"ill-formed" does not conform to the 'extensions' ABNF}
    end
  end

  describe "when assigns the 'v-macron-v-colon' sequence to the extensions" do
    it "raises an InvalidComponentError (repeated singletons)" do
      lambda {
        @langtag.extensions_sequence = 'v-macron-v-colon'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{repeated singletons}
    end
  end

  describe "when assigns the 'v-macron-V-colon-p-kana-P-hyphen' sequence to the extensions" do
    it "raises an InvalidComponentError (repeated singletons)" do
      lambda {
        @langtag.extensions_sequence = 'v-macron-V-colon-p-kana-P-hyphen'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{repeated singletons}
    end
  end

  describe "when assigns nil to the extensions" do

    it "assigns extensions to nil" do
      @langtag.extensions_sequence = nil
      @langtag.singletons.should be_nil
      @langtag.extensions_sequence.should be_nil
      @langtag.should_not have_extension('p')
      @langtag.should_not have_extension('v')
    end

    it "removes an old sequence of extensions from a composition" do
      @langtag.extensions_sequence = nil
      @langtag.composition.should == 'ja-latn-hepburn'
      @langtag.tag.should == 'ja-Latn-hepburn'
    end

    it "does not expose extensions when inspected" do
      @langtag.inspect.should =~ %r{ja-Latn-hepburn}
    end

  end

  describe "when assigns the 'v-oh-ou-oo-s-MFA' sequence to the extensions" do

    before :each do
      @langtag.extensions_sequence = 'v-oh-ou-oo-s-MFA'
    end

    it "has a 'v' singleton" do
      @langtag.should have_singleton('v')
      @langtag.should have_singleton('V')
    end

    it "exposes a 'v' extension as an Array" do
      @langtag.extension('v').should be_an_instance_of ::Array
      @langtag.extension('v').size.should == 3
      @langtag.extension('v').should == ['oh', 'ou', 'oo'] # Satoh, Satoo or Satou
      @langtag.extension('V').should == ['oh', 'ou', 'oo']
    end

    it "has an 's' singleton" do
      @langtag.should have_singleton('s')
      @langtag.should have_singleton('S')
    end

    it "exposes an 's' extension as an Array" do
      @langtag.extension('s').should be_an_instance_of ::Array
      @langtag.extension('s').size.should == 1
      @langtag.extension('s').should == ['MFA'] # Ministry of Foreign Affairs standard
      @langtag.extension('S').should == ['MFA']
    end

    it "has no 'p' singleton" do
      @langtag.should_not have_singleton('p')
      @langtag.should_not have_singleton('P')
      @langtag.extension('p').should be_nil
      @langtag.extension('P').should be_nil
    end

    it "exposes a new list of singletons as an Array" do
      @langtag.singletons.should be_an_instance_of ::Array
      @langtag.singletons.should == ['s', 'v']
    end

    it "exposes a new sequence of extensions" do
      @langtag.extensions_sequence.should == "v-oh-ou-oo-s-MFA"
    end

    it "exposes a new sequence of extensions in a composition" do
      @langtag.composition.should == "ja-latn-hepburn-v-oh-ou-oo-s-mfa"
      @langtag.tag.should == "ja-Latn-hepburn-v-oh-ou-oo-s-MFA"
    end

    it "exposes a new sequence of extensions when inspected" do
      @langtag.inspect.should =~ %r{ja-Latn-hepburn-v-oh-ou-oo-s-MFA}
    end

  end

end

# privateuse
describe Lang::Tag, "'el-x-koine'" do

  before :each do
    @langtag = Lang::Tag('el-x-koine')
  end

  it "has an 'x-koine' privateuse sequence" do
    @langtag.privateuse_sequence.should == 'x-koine'
  end

  it "exposes privateuse components as an Array" do
    @langtag.privateuse.should be_an_instance_of ::Array
    @langtag.privateuse.size.should == 1
    @langtag.privateuse.should == ['koine']
  end

  it "exposes privateuse components in a composition" do
    @langtag.composition.should == 'el-x-koine'
    @langtag.tag.should == 'el-x-koine'
  end

  it "exposes privateuse components when inspected" do
    @langtag.inspect.should =~ %r{el-x-koine}
  end

  describe "when assigns nil to the privateuse" do

    it "has no privateuse sequence" do
      @langtag.privateuse_sequence = nil
      @langtag.privateuse_sequence.should be_nil
      @langtag.privateuse.should be_nil
    end

    it "removes an old privateuse sequence from a composition" do
      @langtag.privateuse_sequence = nil
      @langtag.composition.should == 'el'
      @langtag.tag.should == 'el'
    end

    it "does not expose privateuse components when inspected" do
      @langtag.inspect.should =~ %r{el}
    end

  end

  describe "when assigns the 'ill-formed' sequence to the privateuse" do
    it "raises an InvalidComponentError (ill-formed sequence)" do
      lambda {
        @langtag.privateuse_sequence = 'ill-formed'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{"ill-formed" does not conform to the 'privateuse' ABNF}
    end
  end

  describe "when assigns the 'x-Attic' sequence to the privateuse" do

    before :each do
      @langtag.privateuse_sequence = 'x-Attic'
    end

    it "has an 'x-Attic' privateuse sequence" do
      @langtag.privateuse_sequence.should == 'x-Attic'
    end

    it "exposes new privateuse components as an Array" do
      @langtag.privateuse.should be_an_instance_of ::Array
      @langtag.privateuse.size.should == 1
      @langtag.privateuse.should == ['Attic']
    end

    it "exposes new privateuse components in a composition" do
      @langtag.composition.should == 'el-x-attic'
      @langtag.tag.should == 'el-x-Attic'
    end

    it "exposes privateuse components when inspected" do
      @langtag.inspect.should =~ %r{el-x-Attic}
    end

  end

end

describe Lang::Tag, ".parse" do

  it "returns the argument passed, if it is already a Lang::Tag" do
    @langtag = Lang::Tag.parse('de-DE')
    Lang::Tag.parse(@langtag).should be_equal @langtag
  end

  it "creates a new Lang::Tag object otherwise" do
    @langtag = Lang::Tag.new
    @langtag.should_receive(:recompose).with('de-DE').and_return @langtag # proxy to #recompose
    Lang::Tag.should_receive(:new).and_return(@langtag)
    Lang::Tag.parse('de-DE').should == @langtag
  end

end

describe Lang::Tag, "#recompose" do
  extend Suite

  before :each do
    @langtag = Lang::Tag.new
  end

  it "raises a TypeError when called with 42 (which is not stringable)" do
    lambda { @langtag.recompose(42) }.should raise_error TypeError, %r{Can't convert Fixnum into String}
  end

  it "raises an ArgumentError when called with 'zh-hakka' ('grandfathered' Language-Tag)" do
    lambda { @langtag.recompose('zh-hakka') }.
    should raise_error ArgumentError, %r{Ill-formed, grandfathered or 'privateuse' Language-Tag}
  end

  it "raises an ArgumentError when called with 'i-navajo' ('grandfathered' and irregular Language-Tag)" do
    lambda { @langtag.recompose('i-navajo') }.
    should raise_error ArgumentError, %r{Ill-formed, grandfathered or 'privateuse' Language-Tag}
  end

  it "raises an ArgumentError when called with 'x-private-sequence' ('privateuse' Language-Tag)" do
    lambda { @langtag.recompose('x-private-sequence') }.
    should raise_error ArgumentError, %r{Ill-formed, grandfathered or 'privateuse' Language-Tag}
  end

  suite('www.langtag.net/broken-tags.txt') do |snippet,_|
    it "raises an ArgumentError when called with '#{snippet}' (ill-formed Language-Tag)" do
      lambda { @langtag.recompose(snippet) }.
      should raise_error ArgumentError, %r{Ill-formed, grandfathered or 'privateuse' Language-Tag}
    end
  end

  it "raises an ArgumentError when called with 'en-a-some-ext-a-another-ext' (repeated singletons)" do
    lambda { @langtag.recompose('en-a-some-ext-a-another-ext') }.
    should raise_error Lang::Tag::InvalidComponentError, %r{repeated singletons}
  end

  it "raises an ArgumentError when called with 'sl-rozaj-rozaj' (repeated variants)" do
    lambda { @langtag.recompose('sl-rozaj-rozaj') }.
    should raise_error Lang::Tag::InvalidComponentError, %r{repeated variants}
  end

end

describe Lang::Tag, "#subtags_count" do

  it "considers the tag 'hak' cosisits of the one subtag" do
    Lang::Tag('hak').subtags_count.should == 1
  end

  it "considers the tag 'de-DE' consists of 2 subtags" do
    Lang::Tag('de-DE').subtags_count.should == 2
  end

  it "considers the tag 'de-Latn-DE' consists of 3 subtags" do
    Lang::Tag('de-Latn-DE').subtags_count.should == 3
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk' consists of 7 subtags" do
    Lang::Tag('de-Latn-DE-u-attr-co-phonebk').subtags_count.should == 7
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk-x-private-use' consists of 10 subtags" do
    Lang::Tag('de-Latn-DE-u-attr-co-phonebk-x-private-use').subtags_count.should == 10
  end

end

describe Lang::Tag, "#length" do

  it "considers the tag 'hak' cosisits of 3 chars" do
    Lang::Tag('hak').length.should == 3
  end

  it "considers the tag 'de-DE' consists of 5 chars" do
    Lang::Tag('de-DE').length.should == 5
  end

  it "considers the tag 'de-Latn-DE' consists of 10 chars" do
    Lang::Tag('de-Latn-DE').length.should == 10
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk' consists of 28 chars" do
    Lang::Tag('de-Latn-DE-u-attr-co-phonebk').length.should == 28
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk-x-private-use' consists of 42 chars" do
    Lang::Tag('de-Latn-DE-u-attr-co-phonebk-x-private-use').length.should == 42
  end

end

describe Lang::Tag, "#validate" do

  before :each do
    @langtag = Lang::Tag.new
  end

  it "does not allow langtags without language" do
    lambda { @langtag.script = 'Latn'
    }.should raise_error Lang::Tag::InvalidComponentError, %r{Primary subtag cannot be omitted}
  end

  it "does not allow grandfathered langtags" do
    lambda {
      @langtag.language = 'zh'
      @langtag.variants_sequence = 'hakka'
    }.should raise_error Lang::Tag::Error, %r{Grandfathered Language-Tag: "zh-hakka"}
  end

end

describe Lang::Tag, "#defer_validation" do

  before :each do
    @langtag = Lang::Tag.new
    @invalid = lambda do
      @langtag.variants_sequence = 'hepburn'
      @langtag.script = 'Latn'
    end
  end

  it "defers validation" do
    @langtag.defer_validation do
      lambda(&@invalid).should_not raise_error
      @langtag.language = 'ja'
    end
  end

  it "revalidates self after block execution" do
    @langtag = Lang::Tag.new
    lambda { @langtag.defer_validation &@invalid
    }.should raise_error Lang::Tag::InvalidComponentError, %r{Primary subtag cannot be omitted}
  end

end

describe Lang::Tag, "formatting", "with #nicecase" do

  it "transforms 'dE' to 'de'" do
    nicecased = Lang::Tag('de')
    candidate = Lang::Tag('dE').nicecase
    candidate.language.should == 'de'
    candidate.primary.should == 'de'
    candidate.extlang.should == nil
    candidate.should == nicecased
  end

  it "transforms 'zH-hAk' to 'zh-hak'" do
    nicecased = Lang::Tag('zh-hak')
    candidate = Lang::Tag('zH-hAk').nicecase
    candidate.language.should == 'zh-hak'
    candidate.primary.should == 'zh'
    candidate.extlang.should == 'hak'
    candidate.should == nicecased
  end

  it "transforms 'de-De' to 'de-DE'" do
    nicecased = Lang::Tag('de-DE')
    candidate = Lang::Tag('de-De').nicecase
    candidate.region.should == 'DE'
    candidate.should == nicecased
  end

  it "transforms 'de-lAtN-DE' to 'de-Latn-DE'" do
    nicecased = Lang::Tag('de-Latn-DE')
    candidate = Lang::Tag('de-lAtN-de').nicecase
    candidate.script.should == 'Latn'
    candidate.should == nicecased
  end

  it "transforms 'sl-rOzAj-NeDiS' to 'sl-rozaj-nedis'" do
    nicecased = Lang::Tag('sl-rozaj-nedis')
    candidate = Lang::Tag('sl-rOzAj-NeDiS').nicecase
    candidate.variants_sequence.should == 'rozaj-nedis'
    candidate.should == nicecased
  end

  it "transforms 'de-U-aTtR-cO-pHoNeBk-A-eXtEnDeD' to 'de-u-attr-co-phonebk-a-extended'" do
    nicecased = Lang::Tag('de-u-attr-co-phonebk-a-extended')
    candidate = Lang::Tag('de-U-aTtR-cO-pHoNeBk-A-eXtEnDeD').nicecase
    candidate.extensions_sequence.should == 'u-attr-co-phonebk-a-extended'
    candidate.should == nicecased
  end

  it "transforms 'el-X-aTtIc' to 'el-x-attic'" do
    nicecased = Lang::Tag('el-x-attic')
    candidate = Lang::Tag('el-X-aTtIc').nicecase
    candidate.privateuse_sequence.should == 'x-attic'
    candidate.should == nicecased
  end

end

describe Lang::Tag, "#variants=" do

  it "attempts to set the sequence of variants via the #variants_sequence= method" do
    tag = Lang::Tag('sl')
    tag.should_receive(:variants_sequence=).with('rozaj-solba-1994')
    tag.variants = 'rozaj', 'solba', 1994
  end

end

# EOF