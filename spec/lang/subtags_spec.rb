# encoding: utf-8

require File.expand_path File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Lang::Subtags, ".Language" do

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Language

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: language
Subtag: et
Description: Estonian
Added: 2005-10-16
Suppress-Script: Latn
Scope: macrolanguage
%%
REGISTRY
  end

  describe "when called with a string 'et'" do

    it "loads a language 'et' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(8).times.and_return(@registry)
      @language = Lang::Subtags::Language('et')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @language = Lang::Subtags::Language('et')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @language = Lang::Subtags::Language('eT')
    end

    after :each do
      @language.should be_an_instance_of Lang::Subtags::Language
      @language.name.should == 'et'
      @language.description.should == 'Estonian'
      @language.added_at.should == '2005-10-16'
      @language.scope.should == 'macrolanguage'
      @language.suppress_script.should == 'Latn'
      @language.should_not be_deprecated
    end

  end

end

describe Lang::Subtags, ".Extlang" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: extlang
Subtag: hak
Description: Hakka Chinese
Added: 2009-07-29
Preferred-Value: hak
Prefix: zh
Macrolanguage: zh
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Extlang

  describe "when called with a string 'hak'" do

    it "loads an extlang 'hak' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(9).times.and_return(@registry)
      @extlang = Lang::Subtags::Extlang('hak')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @extlang = Lang::Subtags::Extlang('hak')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @extlang = Lang::Subtags::Extlang('hAk')
    end

    after :each do
      @extlang.should be_an_instance_of Lang::Subtags::Extlang
      @extlang.name.should == 'hak'
      @extlang.description.should == 'Hakka Chinese'
      @extlang.added_at.should == '2009-07-29'
      @extlang.preferred_value.should == 'hak'
      @extlang.prefix.should == 'zh'
      @extlang.macrolanguage.should == 'zh'
      @extlang.should_not be_deprecated
    end

  end

end

describe Lang::Subtags, ".Script" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: script
Subtag: Hang
Description: Hangul
Description: Hangŭl
Description: Hangeul
Added: 2005-10-16
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Script

  describe "when called with a string 'Hang'" do

    it "loads a script 'Hang' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(8).times.and_return(@registry)
      @script = Lang::Subtags::Script('Hang')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @script = Lang::Subtags::Script('Hang')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @script = Lang::Subtags::Script('hAnG')
    end

    after :each do
      @script.should be_an_instance_of Lang::Subtags::Script
      @script.name.should == 'Hang'
      @script.description.should == "Hangul\nHangŭl\nHangeul"
      @script.added_at.should == '2005-10-16'
      @script.should_not be_deprecated
    end

  end

end

describe Lang::Subtags, ".Region" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: region
Subtag: DD
Description: German Democratic Republic
Added: 2005-10-16
Deprecated: 1990-10-30
Preferred-Value: DE
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Region

  describe "when called with a string 'DD'" do

    it "loads a region 'DD' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(8).times.and_return(@registry)
      @region = Lang::Subtags::Region('DD')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @region = Lang::Subtags::Region('DD')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @region = Lang::Subtags::Region('dD')
    end

    after :each do
      @region.should be_an_instance_of Lang::Subtags::Region
      @region.name.should == 'DD'
      @region.description.should == 'German Democratic Republic'
      @region.added_at.should == '2005-10-16'
      @region.deprecated_at.should == '1990-10-30'
      @region.preferred_value.should == 'DE'
      @region.should be_deprecated
    end

  end

end

describe Lang::Subtags, ".Variant" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: variant
Subtag: heploc
Description: Hepburn romanization, Library of Congress method
Added: 2009-10-01
Deprecated: 2010-02-07
Preferred-Value: alalc97
Prefix: ja-Latn-hepburn
Comments: Preferred tag is ja-Latn-alalc97
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Variant

  describe "when called with a string 'heploc'" do

    it "loads a variant 'heploc' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(10).times.and_return(@registry)
      @variant = Lang::Subtags::Variant('heploc')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @variant = Lang::Subtags::Variant('heploc')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @variant = Lang::Subtags::Variant('hEpLoC')
    end

    after :each do
      @variant.should be_an_instance_of Lang::Subtags::Variant
      @variant.name.should == 'heploc'
      @variant.added_at.should == '2009-10-01'
      @variant.deprecated_at.should == '2010-02-07'
      @variant.preferred_value.should == 'alalc97'
      @variant.prefixes.should == ['ja-Latn-hepburn']
      @variant.comments.should == 'Preferred tag is ja-Latn-alalc97'
      @variant.should be_deprecated
    end

  end

end

describe Lang::Subtags, ".Grandfathered" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: grandfathered
Tag: i-navajo
Description: Navajo
Added: 1997-09-19
Deprecated: 2000-02-18
Preferred-Value: nv
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Grandfathered

  describe "when called with a string 'i-navajo'" do

    it "loads a grandfathered tag 'i-navajo' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(8).times.and_return(@registry)
      @grandfathered = Lang::Subtags::Grandfathered('i-navajo')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @grandfathered = Lang::Subtags::Grandfathered('i-navajo')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @grandfathered = Lang::Subtags::Grandfathered('i-nAvAjo')
    end

    after :each do
      @grandfathered.should be_an_instance_of Lang::Subtags::Grandfathered
      @grandfathered.name.should == 'i-navajo'
      @grandfathered.added_at.should == '1997-09-19'
      @grandfathered.deprecated_at.should == '2000-02-18'
      @grandfathered.preferred_value.should == 'nv'
      @grandfathered.description.should == 'Navajo'
      @grandfathered.should be_deprecated
    end

  end

end

describe Lang::Subtags, ".Redundant" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: redundant
Tag: de-AT-1996
Description: German, Austrian variant, orthography of 1996
Added: 2001-07-17
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Redundant

  describe "when called with a string 'de-AT-1996'" do

    it "loads a redundant tag 'de-AT-1996' from a local copy of the IANA registry" do
      Lang::Subtags.should_receive(:_search).and_return(0)
      Lang::Subtags.should_receive(:_registry).exactly(6).times.and_return(@registry)
      @redundant = Lang::Subtags::Redundant('de-AT-1996')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @redundant = Lang::Subtags::Redundant('de-AT-1996')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:_search)
      Lang::Subtags.should_not_receive(:_registry)
      @redundant = Lang::Subtags::Redundant('dE-aT-1996')
    end

    after :each do
      @redundant.should be_an_instance_of Lang::Subtags::Redundant
      @redundant.name.should == 'de-AT-1996'
      @redundant.added_at.should == '2001-07-17'
      @redundant.description.should == 'German, Austrian variant, orthography of 1996'
      @redundant.should_not be_deprecated
    end

  end

end

# EOF