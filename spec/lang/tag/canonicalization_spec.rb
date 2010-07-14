require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require 'lang/tag/canonicalization'

describe Lang::Tag, "#canonicalize" do

  extend RegistryHelper
  stub_memoization_for(*Lang::Subtags::Entry.subclasses)

  it "canonicalizes 'sgn-JP' to 'jsl' (redundand tag)" do
    langtag = Lang::Tag('sgn-JP')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('jsl')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'zh-yue' to 'yue'" do
    langtag = Lang::Tag('zh-yue')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('yue')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'zh-yue-Hant-HK' to 'yue-Hant-HK'" do
    langtag = Lang::Tag('zh-yue-Hant-HK')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('yue-Hant-HK')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'xx' (language is not registered)" do
    langtag = Lang::Tag('xx')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-xxx' (extlang is not registered)" do
    langtag = Lang::Tag('ja-xxx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "xxx" is not registered}
  end

  it "replaces primary language subtag when canonicalizes 'xx-yue'" do
    langtag = Lang::Tag('xx-yue')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('yue')
    canonical.should be_same(langtag)
    canonical.primary.should == 'yue'
    canonical.extlang.should == nil
  end

  it "canonicalizes 'zh-cmn-Hant' to 'cmn-Hant'" do
    langtag = Lang::Tag('zh-cmn-Hant')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('cmn-Hant')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'zh-cmn-Hans' to 'cmn-Hans'" do
    langtag = Lang::Tag('zh-cmn-Hans')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('cmn-Hans')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'de-Qaax' to 'de-Qaax' (privateuse script)" do
    langtag = Lang::Tag('de-Qaax')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-Qaax')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'de-DD' to 'de-DE' (obsolete region)" do
    langtag = Lang::Tag('de-DD')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-DE')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'de-QA' to 'de-QA' (privateuse region)" do
    langtag = Lang::Tag('de-QA')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-QA')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'de-000' (region is not registered)" do
    langtag = Lang::Tag('de-000')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Region "000" is not registered}
  end

  it "canonicalizes 'de-Latn-DD' to 'de-Latn-DE' (obsolete region)" do
    langtag = Lang::Tag('de-Latn-DD')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-Latn-DE')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-Xxxx' (script is not registered)" do
    langtag = Lang::Tag('ja-Xxxx')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Script "Xxxx" is not registered}
  end

  it "canonicalizes 'ja-Latn-hepburn-heploc' to 'ja-Latn-hepburn-alalc97' (obsolete variant)" do
    langtag = Lang::Tag('ja-Latn-hepburn-heploc')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('ja-Latn-hepburn-alalc97')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ja-Latn-alalc97' to 'ja-Latn-alalc97' (everything OK; alalc97 does not require any prefix)" do
    langtag = Lang::Tag('ja-Latn-alalc97')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('ja-Latn-alalc97')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-Latn-xxxxx' (variant is not registered)" do
    langtag = Lang::Tag('ja-Latn-xxxxx')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Variant "xxxxx" is not registered}
  end

  # extensions
  it "canonicalizes 'de-u-attr-co-phonebk-a-extended' to 'de-a-extended-u-attr-co-phonebk'" do
    langtag = Lang::Tag('de-u-attr-co-phonebk-a-extended')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-a-extended-u-attr-co-phonebk')
    canonical.should be_same(langtag)
  end


end

describe Lang::Tag, "#to_extlang_form" do

  it "not yet implemented" do
    langtag = Lang::Tag('yue')
    lambda { langtag.to_extlang_form }.
    should raise_error NotImplementedError
  end

end

describe Lang::Tag, "#suppress_script" do

  it "raises a Canonicalization::Error when attempts to remove script from the tag 'xx-Latn' (language not registered)" do
    langtag = Lang::Tag('xx-Latn')
    lambda { langtag.suppress_script }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "removes script from the tag 'ja-Jpan'" do
    langtag = Lang::Tag('ja-Jpan')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag('ja')
    candidate.script.should == nil
  end

  it "removes script from the tag 'de-Latn-DD'" do
    langtag = Lang::Tag('de-Latn-DD')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag('de-DD')
    candidate.script.should == nil
  end

  it "removes script from the tag 'de-Latn-DE'" do
    langtag = Lang::Tag('de-Latn-DE')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag('de-DE')
    candidate.script.should == nil
  end

  it "removes script from the tag 'sl-Latn-IT-rozaj-1994'" do
    langtag = Lang::Tag('sl-Latn-IT-rozaj-1994')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag('sl-IT-rozaj-1994')
    candidate.script.should == nil
  end

  it "does not remove script from the tag 'de-Qaax' (privateuse script)" do
    langtag = Lang::Tag('de-Qaax')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag('de-Qaax')
    candidate.script.should == 'Qaax'
  end

end

describe Lang::Tag, "#validate_language" do

  it "successfully validates language in the tag 'jsl'" do
    langtag = Lang::Tag('jsl')
    lambda { langtag.validate_language }.
    should_not raise_error
  end

  it "successfully validates language in the tag 'zh-yue'" do
    langtag = Lang::Tag('zh-yue')
    lambda { langtag.validate_language }.
    should_not raise_error
  end

  it "successfully validates language in the tag 'zh-YUE' (case-insensitivity)" do
    langtag = Lang::Tag('zh-YUE')
    lambda { langtag.validate_language }.
    should_not raise_error
  end

  it "raises a Canonicalization::Error when attempts to validate language in the tag 'xx'" do
    langtag = Lang::Tag('xx')
    lambda { langtag.validate_language }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to validate language in the tag 'xx-yue'" do
    langtag = Lang::Tag('xx-yue')
    lambda { langtag.validate_language }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "yue" requires prefix "zh"}
  end

end

describe Lang::Tag, "#validate_script" do

  it "successfully validates script in the tag 'ru-Cyrl'" do
    langtag = Lang::Tag('ru-Cyrl')
    lambda { langtag.validate_script }.
    should_not raise_error
  end

  it "successfully validates region in the tag 'ru-Qaai' (privateuse script)" do
    langtag = Lang::Tag('de-Qaai')
    lambda { langtag.validate_script }.
    should_not raise_error
  end

  it "raises a Canonicalization::Error when attempts to validate script in the tag 'ru-Xxxx'" do
    langtag = Lang::Tag('de-Xxxx')
    lambda { langtag.validate_script }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Script "Xxxx" is not registered}
  end

end

describe Lang::Tag, "#validate_region" do

  it "successfully validates region in the tag 'de-DE'" do
    langtag = Lang::Tag('de-DE')
    lambda { langtag.validate_region }.
    should_not raise_error
  end

  it "successfully validates region in the tag 'de-QA' (privateuse region)" do
    langtag = Lang::Tag('de-QA')
    lambda { langtag.validate_region }.
    should_not raise_error
  end

  it "raises a Canonicalization::Error when attempts to validate region in the tag 'de-000'" do
    langtag = Lang::Tag('de-000')
    lambda { langtag.validate_region }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Region "000" is not registered}
  end

end

describe Lang::Tag, "#validate_variants" do

  it "successfully validates variants in the tag 'sl-rozaj'" do
    langtag = Lang::Tag('sl-rozaj')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'SL-rozaj' (case-insensitivity)" do
    langtag = Lang::Tag('SL-rozaj')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'sl-rozaj-1994'" do
    langtag = Lang::Tag('sl-rozaj-1994')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'sl-rozaj-biske-1994'" do
    langtag = Lang::Tag('sl-rozaj-biske-1994')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'sl-Latn-IT-rozaj-biske-1994'" do
    langtag = Lang::Tag('sl-Latn-IT-rozaj-biske-1994')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'sl-rozaj-njiva-1994'" do
    langtag = Lang::Tag('sl-rozaj-njiva-1994')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'sl-rozaj-osojs-1994'" do
    langtag = Lang::Tag('sl-rozaj-osojs-1994')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "successfully validates variants in the tag 'sl-rozaj-solba-1994'" do
    langtag = Lang::Tag('sl-rozaj-solba-1994')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "raises a Canonicalization::Error when attempts to validate variants in the tag 'sl-xxxxx'" do
    langtag = Lang::Tag('sl-xxxxx')
    lambda { langtag.validate_variants }.
    should raise_error Lang::Tag::Canonicalization::Error,
      %r{Variant "xxxxx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to validate variants in the tag 'sl-1994-rozaj-biske'" do
    langtag = Lang::Tag('sl-1994-rozaj-biske')
    lambda { langtag.validate_variants }.
    should raise_error Lang::Tag::Canonicalization::Error,
      %r{Variant "1994" requires one of following prefixes: "sl-rozaj", "sl-rozaj-biske", "sl-rozaj-njiva", "sl-rozaj-osojs", "sl-rozaj-solba"}
  end

  it "raises a Canonicalization::Error when attempts to validate variants in the tag 'sl-rozaj-1994-biske' (bad prefix)" do
    langtag = Lang::Tag('sl-rozaj-1994-biske')
    lambda { langtag.validate_variants }.
    should raise_error Lang::Tag::Canonicalization::Error,
      %r{Variant "biske" requires one of following prefixes: "sl-rozaj"}
  end

  it "successfully validates variants in the tag 'ja-lAtN-hEpBuRn-hEpLoC' (case-insensitivity)" do
    langtag = Lang::Tag('ja-lAtN-hEpBuRn-hEpLoC')
    lambda { langtag.validate_variants }.
    should_not raise_error
  end

  it "raises a Canonicalization::Error when attempts to validate variants in the tag 'ja-Latn-heploc-alalc97'" do
    langtag = Lang::Tag('ja-Latn-heploc-alalc97')
    lambda { langtag.validate_variants }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Variant "heploc" requires one of following prefixes: "ja-Latn-hepburn"}
  end

end

# EOF