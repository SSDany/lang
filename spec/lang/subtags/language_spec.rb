# encoding: utf-8

require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Subtags::Language, "'hak'" do

  before :all do
    @registry = StringIO.new <<-REGISTRY
Type: language
Subtag: hak
Description: Hakka Chinese
Added: 2009-07-29
Macrolanguage: zh
%%
Type: language
Subtag: zh
Description: Chinese
Added: 2005-10-16
Scope: macrolanguage
%%
REGISTRY
  end

  extend MemoizationHelper
  stub_memoization_for Lang::Subtags::Language

  before :all do
    Lang::Subtags.should_receive(:_search).and_return(0)
    Lang::Subtags.should_receive(:_registry).exactly(7).times.and_return(@registry)
    @language = Lang::Subtags::Language('hak')
  end

  it "has a macrolanguage 'zh'" do
    @language.macrolanguage.should == 'zh'
  end

  it "loads a (macro) language 'zh' from the local copy of the IANA registry" do
    Lang::Subtags.should_receive(:_search).and_return(93)
    Lang::Subtags.should_receive(:_registry).exactly(7).times.and_return(@registry)
    @macro = @language.macro
    @macro.should be_an_instance_of Lang::Subtags::Language
    @macro.name.should == 'zh'
    @macro.description.should == 'Chinese'
    @macro.scope.should == 'macrolanguage'
    @macro.added_at.should == '2005-10-16'
  end

end

# EOF