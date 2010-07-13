module RegistryHelper

  def stub_memoization_for(*klasses)

    klasses = Lang::Subtags::Entry.subclasses & klasses

    before :all do
      #Lang::Subtags.stub!(:registry_path).and_return(FIXTURES_DIR.join('fake/language-subtags'))
    end

    before :all do
      @entries = {}
      klasses.each { |klass| @entries[klass] = {} }
    end

    before :each do
      klasses.each { |klass|
        klass.should_receive(:entries).
        any_number_of_times.
        and_return(@entries[klass])
      }
    end

  end

end

# EOF