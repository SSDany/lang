# encoding: utf-8

require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Subtags::Extlang, "'hak'" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: language
Subtag: zh
Description: Chinese
Added: 2005-10-16
Scope: macrolanguage
%%
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
  stub_memoization_for Lang::Subtags::Language, Lang::Subtags::Extlang

  before :all do
    Lang::Subtags.should_receive(:_search).and_return(89)
    Lang::Subtags.should_receive(:_registry).exactly(9).times.and_return(@registry)
    @extlang = Lang::Subtags::Extlang('zh')
  end

  it "has a macrolanguage 'zh'" do
    @extlang.macrolanguage.should == 'zh'
  end

  it "loads a (macro) language 'zh' from the local copy of the IANA registry" do
    Lang::Subtags.should_receive(:_search).and_return(0)
    Lang::Subtags.should_receive(:_registry).exactly(7).times.and_return(@registry)
    @macro = @extlang.macro
    @macro.should be_an_instance_of Lang::Subtags::Language
    @macro.name.should == 'zh'
    @macro.description.should == 'Chinese'
    @macro.scope.should == 'macrolanguage'
    @macro.added_at.should == '2005-10-16'
  end

end

# EOF