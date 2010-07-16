# encoding: utf-8

require File.expand_path File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Lang::Subtags, ".Language" do

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Language

  describe "when called with a string 'et'" do

    it "loads a language 'et' from a local copy of the IANA registry" do
      @language = Lang::Subtags::Language('et')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @language = Lang::Subtags::Language('et')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Extlang

  describe "when called with a string 'hak'" do

    it "loads an extlang 'hak' from a local copy of the IANA registry" do
      @extlang = Lang::Subtags::Extlang('hak')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @extlang = Lang::Subtags::Extlang('hak')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Script

  describe "when called with a string 'Hang'" do

    it "loads a script 'Hang' from a local copy of the IANA registry" do
      @script = Lang::Subtags::Script('Hang')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @script = Lang::Subtags::Script('Hang')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Region

  describe "when called with a string 'DD'" do

    it "loads a region 'DD' from a local copy of the IANA registry" do
      @region = Lang::Subtags::Region('DD')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @region = Lang::Subtags::Region('DD')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Variant

  describe "when called with a string 'heploc'" do

    it "loads a variant 'heploc' from a local copy of the IANA registry" do
      @variant = Lang::Subtags::Variant('heploc')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @variant = Lang::Subtags::Variant('heploc')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Grandfathered

  describe "when called with a string 'i-navajo'" do

    it "loads a grandfathered tag 'i-navajo' from a local copy of the IANA registry" do
      @grandfathered = Lang::Subtags::Grandfathered('i-navajo')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @grandfathered = Lang::Subtags::Grandfathered('i-navajo')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Redundant

  describe "when called with a string 'de-AT-1996'" do

    it "loads a redundant tag 'de-AT-1996' from a local copy of the IANA registry" do
      @redundant = Lang::Subtags::Redundant('de-AT-1996')
    end

    it "does not perform search twice" do
      Lang::Subtags.should_not_receive(:load_entry)
      @redundant = Lang::Subtags::Redundant('de-AT-1996')
    end

    it "works case-insensitively" do
      Lang::Subtags.should_not_receive(:load_entry)
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