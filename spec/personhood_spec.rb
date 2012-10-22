require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'spec_helper'

describe 'Juscribe::Personhood' do
  ActiveRecord::Base.send(:include, Juscribe::DisplayOptional)

  describe User do # from spec/dummy app

    def build(*args)
      attrs = args.extract_options!
      described_class.new(attrs)
    end

    before(:each) do
      @colin ||= User.new({
          email:        'caleon@gmail.com',
          username:     'colin',
          first_name:   'colin',
          last_name:    'chun',
          middle_name:  'potenza',
          sex:          1,
          birthdate:    Date.new(1985, 1, 29)
        }, as: :admin)
      @jimbo ||= User.new({
          email:        'jimbo@juscribe.com',
          username:     'jimbo',
          first_name:   'Jim',
          last_name:    'Bo'
        }, as: :admin)
      @marion = User.new({
          username:     'marion',
          first_name:   'Marion',
          last_name:    'Cotillard',
          sex:          0
        }, as: :admin)
    end

    shared_context 'with a lowercased name', name: :lowercased do
      subject { @colin }
    end

    shared_context 'with a normal name', :name do
      subject { @jimbo }
    end

    shared_context 'with email', :email do
      subject { @colin }
    end

    shared_context 'with birthdate', :birthdate do
      subject { @colin }
    end

    shared_context 'with male sex', sex: :male do
      subject { @colin }
    end

    shared_context 'with female sex', sex: :female do
      subject { @marion }
    end

    # describe 'testing', focus: true do
    #   it 'does something' do
    #     puts @colin.inspect
    #     true.should be_true
    #   end
    # end

    describe '#first_and_last_name' do

      context 'with no name' do
        its(:first_and_last_name) { should == '(unnamed)' }
      end

      context 'with a lowercased name', name: :lowercased do
        its(:first_and_last_name) { should == 'colin chun' }
      end

      context 'with a normal name', :name do
        its(:first_and_last_name) { should == 'Jim Bo' }
      end
    end

    describe '#full_name' do

      context 'with no name' do
        its(:full_name) { should == '(unnamed)' }
      end

      context 'with a lowercased name', name: :lowercased do
        its(:full_name) { should == 'colin p. chun' }
      end

      context 'with a normal name', :name do
        its(:full_name) { should == 'Jim Bo' }
      end
    end

    describe '#email_address' do

      context 'with no email' do
        its(:email_address) { should be_nil }
      end

      context 'with a lowercased name', name: :lowercased do
        its(:email_address) { should == 'colin chun <caleon@gmail.com>' }
      end

      context 'with a normal name', :name do
        its(:email_address) { should == 'Jim Bo <jimbo@juscribe.com>' }
      end
    end

    describe '#to_s' do

      context 'with no name' do
        its(:username) { should be_nil }
        its(:to_s) { should == '(unnamed)' }
      end

      context 'with a lowercased name', name: :lowercased do
        its(:username) { should == 'colin' }
        its(:to_s) { should == @colin.username }
      end

      context 'with a normal name', :name do
        its(:username) { should == 'jimbo' }
        its(:to_s) { should == @jimbo.username }
      end
    end

    describe '#sex' do

      context 'with no sex' do
        its([:sex]) { should be_nil }
        its(:sex) { should == '?' }
        specify { subject.sex(:full).should == '(unknown)' }
      end

      context 'with male sex', sex: :male do
        its([:sex]) { should == 1 }
        its(:sex) { should == 'm' }
        specify { subject.sex(:full).should == 'male' }
      end

      context 'with female sex', sex: :female do
        its([:sex]) { should == 0}
        its(:sex) { should == 'f' }
        specify { subject.sex(:full).should == 'female' }
      end
    end

    describe '#male?|#female?|#androgynous?' do

      context 'with no sex' do
        it { should_not be_male }
        it { should_not be_female }
        it { should be_androgynous }
      end

      context 'with male sex', sex: :male do
        it { should be_male }
        it { should_not be_female }
        it { should_not be_androgynous }
      end

      context 'with female sex', sex: :female do
        it { should be_female }
        it { should_not be_male }
        it { should_not be_androgynous }
      end
    end

    describe '#birthdate' do

      context 'with no birthdate' do
        its(:birthdate) { should == Date.today }
      end

      context 'with birthdate', :birthdate do
        its(:birthdate) { should be_a_kind_of Date }
        its('birthdate.year')   { should == 1985 }
        its('birthdate.month')  { should == 1 }
        its('birthdate.day')    { should == 29 }
      end
    end

    describe '#age' do

      context 'with no birthdate' do
        its(:age) { should == 0 }
      end

      context 'with birthdate', :birthdate do
        its(:age) do
          years_difference = Date.today.year - @colin.birthdate.year
          bday_this_year = @colin.birthdate + years_difference.years
          age = years_difference - (bday_this_year > Date.today ? 1 : 0)
          should == age
        end
      end
    end

    describe 'validations' do

      it 'should reject a blank first_name' do
        build(:user, first_name: nil).should have_error(:blank).on(:first_name)
        build(:user, first_name: '' ).should have_error(:blank).on(:first_name)
        build(:user, first_name: ' ').should have_error(:blank).on(:first_name)
      end

      # it 'should reject a first_name which includes numerics' do
      #   user = build(:user, first_name: 'j0hn')
      #   user.should_not be_valid
      #   user.should have_error(:regexp).on(:first_name)
      # end

      # it 'should reject a first_name with symbols and spaces' do
      #   user = build(:user, first_name: 'mbaT !@ ahs!')
      #   user.should_not be_valid
      #   user.should have_error(:regexp).on(:first_name)
      # end

      it 'should reject a blank last_name' do
        build(:user, last_name: nil).should have_error(:blank).on(:last_name)
        build(:user, last_name: '' ).should have_error(:blank).on(:last_name)
        build(:user, last_name: ' ').should have_error(:blank).on(:last_name)
      end

      # it 'should reject a last_name which includes numerics' do
      #   user = build(:user, last_name: 'sm1th')
      #   user.should_not be_valid
      #   user.should have_error(:regexp).on(:last_name)
      # end

      # it 'should reject a last_name with symbols' do
      #   user = build(:user, last_name: 'mbaT!@ahs!')
      #   user.should_not be_valid
      #   user.should have_error(:regexp).on(:last_name)
      # end
    end
  end
end
