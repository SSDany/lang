require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require 'lang/tag/canonicalization'

describe Lang::Tag::Canonicalization, "#canonicalize" do

  extend RegistryHelper
  stub_memoization_for(*Lang::Subtags::Entry.subclasses)

  it "canonicalizes 'sgn-JP' to 'jsl' (redundand tag)" do
    langtag = Lang::Tag::Langtag('sgn-JP')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('jsl')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'jsl' to 'jsl' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('jsl')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('jsl')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'qaa' to 'qaa' (private language; already in canonical form)" do
    langtag = Lang::Tag::Langtag('qaa')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('qaa')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'in' to 'id' (Indonesian)" do
    langtag = Lang::Tag::Langtag('in')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('id')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'xx' (language is not registered)" do
    langtag = Lang::Tag::Langtag('xx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "canonicalizes 'zh-yue' to 'yue'" do
    langtag = Lang::Tag::Langtag('zh-yue')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('yue')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ZH-YUE' to 'yue' (case-insensitivity)" do
    langtag = Lang::Tag::Langtag('ZH-YUE')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('yue')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'zh-yue-Hant-HK' to 'yue-Hant-HK'" do
    langtag = Lang::Tag::Langtag('zh-yue-Hant-HK')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('yue-Hant-HK')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'xx' (language is not registered)" do
    langtag = Lang::Tag::Langtag('xx')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-xxx' (extlang is not registered)" do
    langtag = Lang::Tag::Langtag('ja-xxx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "xxx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'xx-yue' (bad prefix)" do
    langtag = Lang::Tag::Langtag('xx-yue')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "yue" requires prefix "zh"}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'qaa-yue' (bad prefix)" do
    langtag = Lang::Tag::Langtag('qaa-yue')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Extlang "yue" requires prefix "zh"}
  end

  it "canonicalizes 'zh-cmn-Hant' to 'cmn-Hant'" do
    langtag = Lang::Tag::Langtag('zh-cmn-Hant')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('cmn-Hant')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'zh-cmn-Hans' to 'cmn-Hans'" do
    langtag = Lang::Tag::Langtag('zh-cmn-Hans')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('cmn-Hans')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'de-Qaax' to 'de-Qaax' (already in canonical form; privateuse script)" do
    langtag = Lang::Tag::Langtag('de-Qaax')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('de-Qaax')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ru-Cyrl' to 'ru-Cyrl' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('ru-Cyrl')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('ru-Cyrl')
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

    langtag = Lang::Tag::Langtag('zh-Test')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('zh-Pref')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ru-Xxxx' (script is not registered)" do
    langtag = Lang::Tag::Langtag('de-Xxxx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Script "Xxxx" is not registered}
  end

  it "canonicalizes 'de-DE' to 'de-DE' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('de-DE')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('de-DE')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'de-DD' to 'de-DE' (obsolete region)" do
    langtag = Lang::Tag::Langtag('de-DD')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('de-DE')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'de-QA' to 'de-QA' (privateuse region)" do
    langtag = Lang::Tag::Langtag('de-QA')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('de-QA')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'de-000' (region is not registered)" do
    langtag = Lang::Tag::Langtag('de-000')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Region "000" is not registered}
  end

  it "canonicalizes 'de-Latn-DD' to 'de-Latn-DE' (obsolete region)" do
    langtag = Lang::Tag::Langtag('de-Latn-DD')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('de-Latn-DE')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj' to 'sl-rozaj' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-rozaj')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-rozaj')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'SL-Rozaj' to 'SL-Rozaj (case-insensitivity, undestructivity)" do
    langtag = Lang::Tag::Langtag('SL-Rozaj')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('SL-Rozaj')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-1994' to 'sl-rozaj-1994' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-rozaj-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-biske-1994' to 'sl-rozaj-biske-1994' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-biske-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-rozaj-biske-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-Latn-IT-rozaj-biske-1994' to 'sl-Latn-IT-rozaj-biske-1994' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-Latn-IT-rozaj-biske-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-Latn-IT-rozaj-biske-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-njiva-1994' to 'sl-rozaj-njiva-1994' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-njiva-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-rozaj-njiva-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-osojs-1994' to 'sl-rozaj-osojs-1994' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-osojs-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-rozaj-osojs-1994')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'sl-rozaj-solba-1994' to 'sl-rozaj-solba-1994' (already in canonical form)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-solba-1994')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('sl-rozaj-solba-1994')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'sl-xxxxx'" do
    langtag = Lang::Tag::Langtag('sl-xxxxx')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
    %r{Variant "xxxxx" is not registered}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'sl-1994-rozaj-biske'" do
    langtag = Lang::Tag::Langtag('sl-1994-rozaj-biske')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
    %r{Variant "1994" requires one of following prefixes: "sl-rozaj", "sl-rozaj-biske", "sl-rozaj-njiva", "sl-rozaj-osojs", "sl-rozaj-solba"}
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'sl-rozaj-1994-biske' (bad prefix)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-1994-biske')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
    %r{Variant "biske" requires one of following prefixes: "sl-rozaj"}
  end

  it "canonicalizes 'ja-lAtN-hEpBuRn' to 'ja-lAtN-hEpBuRn' (case-insensitivity)" do
    langtag = Lang::Tag::Langtag('ja-lAtN-hEpBuRn')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('ja-lAtN-hEpBuRn')
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ja-lAtN-hEpBuRn-HePlOc' to 'ja-lAtN-hEpBuRn-alalc97' (case-insensitivity)" do
    langtag = Lang::Tag::Langtag('ja-lAtN-hEpBuRn-HePlOc')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('ja-lAtN-hEpBuRn-alalc97')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-Latn-heploc-alalc97' (bad prefix)" do
    langtag = Lang::Tag::Langtag('ja-Latn-heploc-alalc97')
    lambda { langtag.canonicalize }.
    should raise_error Lang::Tag::Canonicalization::Error,
    %r{Variant "heploc" requires one of following prefixes: "ja-Latn-hepburn"}
  end

  it "canonicalizes 'ja-Latn-hepburn-heploc' to 'ja-Latn-hepburn-alalc97' (obsolete variant)" do
    langtag = Lang::Tag::Langtag('ja-Latn-hepburn-heploc')
    langtag.variants.should == %w(hepburn heploc)
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('ja-Latn-hepburn-alalc97')
    canonical.variants.should == %w(hepburn alalc97)
    canonical.should be_same(langtag)
  end

  it "canonicalizes 'ja-Latn-alalc97' to 'ja-Latn-alalc97' (everything OK; alalc97 does not require any prefix)" do
    langtag = Lang::Tag::Langtag('ja-Latn-alalc97')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('ja-Latn-alalc97')
    canonical.should be_same(langtag)
  end

  it "raises a Canonicalization::Error when attempts to canonicalize 'ja-Latn-xxxxx' (variant is not registered)" do
    langtag = Lang::Tag::Langtag('ja-Latn-xxxxx')
    lambda { langtag.canonicalize! }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Variant "xxxxx" is not registered}
  end

  # extensions
  it "canonicalizes 'de-u-attr-co-phonebk-a-extended' to 'de-a-extended-u-attr-co-phonebk'" do
    langtag = Lang::Tag::Langtag('de-u-attr-co-phonebk-a-extended')
    canonical = langtag.canonicalize
    canonical.should == Lang::Tag::Langtag('de-a-extended-u-attr-co-phonebk')
    canonical.should be_same(langtag)
  end

end

describe Lang::Tag::Canonicalization, "#canonicalize!" do

  it "does not call #dirty when attempts to canonicalize 'de' (no changes)" do
    langtag = Lang::Tag::Langtag('de')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'de-Latn' (no changes)" do
    langtag = Lang::Tag::Langtag('de-Latn')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'de-DE' (no changes)" do
    langtag = Lang::Tag::Langtag('de-DE')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'sl-rozaj-biske-1994' (no changes)" do
    langtag = Lang::Tag::Langtag('sl-rozaj-biske-1994')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

  it "does not call #dirty when attempts to canonicalize 'en-u-attr-co-phonebk' (no changes)" do
    langtag = Lang::Tag::Langtag('en-u-attr-co-phonebk')
    langtag.should_not_receive(:dirty)
    langtag.canonicalize!
  end

end

describe Lang::Tag::Canonicalization, "#to_extlang_form" do

  it "canonicalizes the tag first" do
    langtag = Lang::Tag::Langtag('yue')
    langtag.should_receive(:canonicalize!).and_return(langtag)
    langtag.to_extlang_form!
  end

  it "transforms 'zh-yue' to 'zh-yue' (already in extlang form)" do
    langtag = Lang::Tag::Langtag('zh-yue')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag::Langtag('zh-yue')
    candidate.should be_same(langtag)
  end

  it "transforms 'yue' to 'zh-yue'" do
    langtag = Lang::Tag::Langtag('yue')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag::Langtag('zh-yue')
    candidate.should be_same(langtag)
  end

  it "transforms 'jsl' to 'sgn-jsl'" do
    langtag = Lang::Tag::Langtag('jsl')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag::Langtag('sgn-jsl')
    candidate.should be_same(langtag)
  end

  it "transforms 'hak-CN' to 'zh-hak-CN'" do
    langtag = Lang::Tag::Langtag('hak-CN')
    candidate = langtag.to_extlang_form
    candidate.should == Lang::Tag::Langtag('zh-hak-CN')
    candidate.should be_same(langtag)
  end

end

describe Lang::Tag::Canonicalization, "#suppress_script" do

  it "raises a Canonicalization::Error when attempts to remove script from the tag 'xx-Latn' (language not registered)" do
    langtag = Lang::Tag::Langtag('xx-Latn')
    lambda { langtag.suppress_script }.
    should raise_error Lang::Tag::Canonicalization::Error, %r{Language "xx" is not registered}
  end

  it "removes script from the tag 'ja-Jpan'" do
    langtag = Lang::Tag::Langtag('ja-Jpan')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag::Langtag('ja')
    candidate.script.should == nil
  end

  it "removes script from the tag 'de-Latn-DD'" do
    langtag = Lang::Tag::Langtag('de-Latn-DD')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag::Langtag('de-DD')
    candidate.script.should == nil
  end

  it "removes script from the tag 'de-Latn-DE'" do
    langtag = Lang::Tag::Langtag('de-Latn-DE')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag::Langtag('de-DE')
    candidate.script.should == nil
  end

  it "removes script from the tag 'sl-Latn-IT-rozaj-1994'" do
    langtag = Lang::Tag::Langtag('sl-Latn-IT-rozaj-1994')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag::Langtag('sl-IT-rozaj-1994')
    candidate.script.should == nil
  end

  it "does not remove script from the tag 'de-Qaax' (privateuse script)" do
    langtag = Lang::Tag::Langtag('de-Qaax')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag::Langtag('de-Qaax')
    candidate.script.should == 'Qaax'
  end

  it "does not remove script from the tag 'qaa-Latn' (privateuse language)" do
    langtag = Lang::Tag::Langtag('qaa-Latn')
    candidate = langtag.suppress_script
    candidate.should == Lang::Tag::Langtag('qaa-Latn')
    candidate.script.should == 'Latn'
  end

end

describe Lang::Tag::Canonicalization, "#suppress_script!" do

  it "does not call #dirty when attempts to handle 'de-DE' (no changes)" do
    langtag = Lang::Tag::Langtag('de-DE')
    langtag.should_not_receive(:dirty)
    langtag.suppress_script!
  end

end

# EOF