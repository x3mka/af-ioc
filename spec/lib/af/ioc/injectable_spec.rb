require 'spec_helper'

module Af
  module Ioc

    class Person
      include Injectable

      attr_resolve :a_prop, :a
      attr_resolve :b_prop, :b, container: :named_container
      attr_resolve :c_prop, :c, name: :other1
      attr_resolve_all :c_all_prop, :c

    end

    class Student < Person
      attr_resolve :d_prop, :d
    end

    describe Injectable do

      let(:named_container_name) { :named_container }

      let!(:default_container) do
        c = Container.new
        c.configure do
          register :a, 1
          register :c, 2
          register :c, 3, name: :other1
          register :c, name: :other2 do
            4
          end
          register :d, 5
        end
        c
      end

      let!(:named_container) do
        c = Container.new(named_container_name)
        c.configure do
          register :b, 5
        end
        c
      end

      let(:person) { Person.new }
      let(:student) { Student.new }

      describe 'injection' do

        it 'should have accessor generated' do
          methods = person.methods.sort - Object.new.methods
          accessors = %w(a_prop a_prop= b_prop b_prop= c_prop c_prop= c_all_prop c_all_prop=).map(&:to_sym)
          expect(methods).to include(*accessors)
        end

        it 'should correctly resolve dependency from default container' do
          expect(person.a_prop).to eq 1
        end

        it 'should correctly resolve dependency from named container' do
          expect(person.b_prop).to eq 5
        end

        it 'should correctly resolve named dependency from default container' do
          expect(person.c_prop).to eq 3
        end

        it 'should correctly resolve dependency with multiple registrations from default container' do
          expect(person.c_all_prop).to eq [2, 3, 4]
        end

      end

      describe 'inheritance' do

        it 'should inherit resolved dependencies' do
          expect(student.a_prop).to eq 1
        end

        it 'can resolve new dependencies' do
          expect(student.d_prop).to eq 5
        end

        it 'should not add accessors to parent class' do
          expect { person.d_prop }.to raise_error(NoMethodError)
        end

      end

    end

  end
end
