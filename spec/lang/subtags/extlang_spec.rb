# encoding: utf-8

require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Subtags::Extlang, "'hak'" do

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Language, Lang::Subtags::Extlang

  before :each do
    @extlang = Lang::Subtags::Extlang('hak')
  end

  it "has a macrolanguage 'zh'" do
    @extlang.macrolanguage.should == 'zh'
  end

  it "loads a (macro) language 'zh' from the local copy of the IANA registry" do
    @macro = @extlang.macro
    @macro.should be_an_instance_of Lang::Subtags::Language
    @macro.name.should == 'zh'
    @macro.description.should == 'Chinese'
    @macro.scope.should == 'macrolanguage'
    @macro.added_at.should == '2005-10-16'
  end

end

# EOF