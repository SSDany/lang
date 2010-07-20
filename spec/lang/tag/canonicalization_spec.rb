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

  it "canonicalizes 'jsl' to 'jsl' (already in canonical form)" do
    langtag = Lang::Tag('jsl')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('jsl')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'qaa' to 'qaa' (private language; already in canonical form)" do
    langtag = Lang::Tag('qaa')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('qaa')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'in' to 'id' (Indonesian)" do
    langtag = Lang::Tag('in')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('id')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'xx'" do
    langtag = Lang::Tag('xx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "canonicalizes 'zh-yue' to 'yue'" do
    langtag = Lang::Tag('zh-yue')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('yue')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ZH-YUE' to 'yue' (case-insensitivity)" do
    langtag = Lang::Tag('ZH-YUE')
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

  it "raises a Canonicalization::Error when attempts to canonicalize 'xx-yue' (bad prefix)" do
    langtag = Lang::Tag('xx-yue')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "yue" requires prefix "zh"}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'qaa-yue' (bad prefix)" do
    langtag = Lang::Tag('qaa-yue')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "yue" requires prefix "zh"}
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

  it "canonicalizes 'de-Qaax' to 'de-Qaax' (already in canonical form; privateuse script)" do
    langtag = Lang::Tag('de-Qaax')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-Qaax')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ru-Cyrl' to 'ru-Cyrl' (already in canonical form)" do
    langtag = Lang::Tag('ru-Cyrl')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('ru-Cyrl')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'zh-Test' to 'zh-Pref' (preferred value of the script subtag; FAKE)" do

    script = Lang::Subtags::Script.new
    script.name = 'Test'
    script.preferred_value = 'Pref'

    preferred = Lang::Subtags::Script.new
    preferred.name = 'Pref'

    Lang::Subtags.should_receive(:Script).with('Test').twice.and_return(script)
    Lang::Subtags.should_receive(:Script).with('Pref').once.and_return(preferred)

    langtag = Lang::Tag('zh-Test')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('zh-Pref')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ru-Xxxx'" do
    langtag = Lang::Tag('de-Xxxx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Script "Xxxx" is not registered}
  end

  it "canonicalizes 'de-DE' to 'de-DE' (already in canonical form)" do
    langtag = Lang::Tag('de-DE')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('de-DE')
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

  it "canonicalizes 'sl-rozaj' to 'sl-rozaj' (already in canonical form)" do
    langtag = Lang::Tag('sl-rozaj')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-rozaj')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'SL-Rozaj' to 'SL-Rozaj (case-insensitivity, undestructivity)" do
    langtag = Lang::Tag('SL-Rozaj')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('SL-Rozaj')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-1994' to 'sl-rozaj-1994' (already in canonical form)" do
    langtag = Lang::Tag('sl-rozaj-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-rozaj-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-biske-1994' to 'sl-rozaj-biske-1994' (already in canonical form)" do
    langtag = Lang::Tag('sl-rozaj-biske-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-rozaj-biske-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-Latn-IT-rozaj-biske-1994' to 'sl-Latn-IT-rozaj-biske-1994' (already in canonical form)" do
    langtag = Lang::Tag('sl-Latn-IT-rozaj-biske-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-Latn-IT-rozaj-biske-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-njiva-1994' to 'sl-rozaj-njiva-1994' (already in canonical form)" do
    langtag = Lang::Tag('sl-rozaj-njiva-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-rozaj-njiva-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-osojs-1994' to 'sl-rozaj-osojs-1994' (already in canonical form)" do
    langtag = Lang::Tag('sl-rozaj-osojs-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-rozaj-osojs-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-solba-1994' to 'sl-rozaj-solba-1994' (already in canonical form)" do
    langtag = Lang::Tag('sl-rozaj-solba-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag('sl-rozaj-solba-1994')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'sl-xxxxx'" do
    langtag = Lang::Tag('sl-xxxxx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
      %r{Variant "xxxxx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'sl-1994-rozaj-biske'" do
    langtag = Lang::Tag('sl-1994-rozaj-biske')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
      %r{Variant "1994" requires one of following prefixes: "sl-rozaj", "sl-rozaj-biske", "sl-rozaj-njiva", "sl-rozaj-osojs", "sl-rozaj-solba"}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'sl-rozaj-1994-biske' (bad prefix)" do
    langtag = Lang::Tag('sl-rozaj-1994-biske')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
      %r{Variant "biske" requires one of following prefixes: "sl-rozaj"}
  end

  it "canonicalizes 'ja-lAtN-hEpBuRn-hEpLoC' (case-insensitivity)" do
    langtag = Lang::Tag('ja-lAtN-hEpBuRn-hEpLoC')
    lambda { langtag.canonicalize }.
    should_not raise_error
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-Latn-heploc-alalc97'" do
    langtag = Lang::Tag('ja-Latn-heploc-alalc97')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Variant "heploc" requires one of following prefixes: "ja-Latn-hepburn"}
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

describe Lang::Tag, "#canonicalize!" do

  it "does not call #dirty when attempts to canonicalize 'de' (no changes)" do
    langtag = Lang::Tag('de')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'de-Latn' (no changes)" do
    langtag = Lang::Tag('de-Latn')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'de-DE' (no changes)" do
    langtag = Lang::Tag('de-DE')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'sl-rozaj-biske-1994' (no changes)" do
    langtag = Lang::Tag('sl-rozaj-biske-1994')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'en-u-attr-co-phonebk' (no changes)" do
    langtag = Lang::Tag('en-u-attr-co-phonebk')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

end

describe Lang::Tag, "#to_extlang_form" do

  it "canonicalizes the tag first" do
    langtag = Lang::Tag('yue')
    langtag.should_receive(:canonicalize!).and_return(langtag)
    langtag.to_extlang_form!
  end

  it "transforms 'zh-yue' to 'zh-yue' (already in extlang form)" do
    langtag = Lang::Tag('zh-yue')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag('zh-yue')
    candidate.should be_same(langtag)
  end

  it "transforms 'yue' to 'zh-yue'" do
    langtag = Lang::Tag('yue')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag('zh-yue')
    candidate.should be_same(langtag)
  end

  it "transforms 'jsl' to 'sgn-jsl'" do
    langtag = Lang::Tag('jsl')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag('sgn-jsl')
    candidate.should be_same(langtag)
  end

  it "transforms 'hak-CN' to 'zh-hak-CN'" do
    langtag = Lang::Tag('hak-CN')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag('zh-hak-CN')
    candidate.should be_same(langtag)
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

  it "does not remove script from the tag 'qaa-Latn' (privateuse language)" do
    langtag = Lang::Tag('qaa-Latn')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag('qaa-Latn')
    candidate.script.should == 'Latn'
  end

end

describe Lang::Tag, "#suppress_script!" do

  it "does not call #dirty when attempts to handle 'de-DE' (no changes)" do
    langtag = Lang::Tag('de-DE')
    langtag.should_not_receive(:dirty)
    langtag.suppress_script!
  end

end

# EOF