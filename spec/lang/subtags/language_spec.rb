# encoding: utf-8

require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Subtags::Language, "'hak'" do

  extend RegistryHelper
  stub_memoization_for Lang::Subtags::Language

  before :each do
    @language = Lang::Subtags::Language('hak')
  end

  it "has a macrolanguage 'zh'" do
    @language.macrolanguage.should == 'zh'
  end

  it "loads a (macro) language 'zh' from the local copy of the IANA registry" do
    @macro = @language.macro
    @macro.should be_an_instance_of Lang::Subtags::Language
    @macro.name.should == 'zh'
    @macro.description.should == 'Chinese'
    @macro.scope.should == 'macrolanguage'
    @macro.added_at.should == '2005-10-16'
  end

end

# EOF