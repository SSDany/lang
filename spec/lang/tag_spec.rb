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
      @langtag.variants.should == ['rozaj', 'nedis']
    end

    it "exposes a new sequence of variants in a composition" do
      @langtag.tag.should == 'sl-Rozaj-nEDIS'
      @langtag.composition.should == 'sl-rozaj-nedis'
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

  end

  describe "when assigns the 'rozaj-biske-rozaj-biske' sequence to the variants" do
    it "raises an InvalidComponentError (repeated variants)" do
      lambda {
        @langtag.variants_sequence = 'rozaj-biske-rozaj-biske'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{Repeated variants: rozaj, biske}
    end
  end

  describe "when assigns the 'Rozaj-Biske-rozaj-biske' sequence to the variants" do
    it "raises an InvalidComponentError (repeated variants)" do
      lambda {
        @langtag.variants_sequence = 'Rozaj-Biske-rozaj-biske'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{Repeated variants: rozaj, biske}
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
      }.should raise_error Lang::Tag::InvalidComponentError, %r{Repeated singletons: v}
    end
  end

  describe "when assigns the 'v-macron-V-colon-p-kana-P-hyphen' sequence to the extensions" do
    it "raises an InvalidComponentError (repeated singletons)" do
      lambda {
        @langtag.extensions_sequence = 'v-macron-V-colon-p-kana-P-hyphen'
      }.should raise_error Lang::Tag::InvalidComponentError, %r{Repeated singletons: p, v}
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
      @langtag.extension('s').should == ['mfa'] # Ministry of Foreign Affairs standard
      @langtag.extension('S').should == ['mfa']
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

  end

end

# EOF