require 'spec_helper'

module Af
  module Ioc

    describe Container do

      let(:default_container_name) { :default }
      let(:named_container_name) { :named }

      let(:default_container) { Container.new }
      let(:named_container) { Container.new(named_container_name) }

      describe 'Class Methods' do

        describe '#containers_count' do

          it 'should be an alias for containers.size' do
            expect(Container.containers_count).to eq Container.containers.size
            default_container
            expect(Container.containers_count).to eq Container.containers.size
          end

        end

        describe '#[]' do

          it 'should be an alias for containers[]' do
            named_container
            expect(Container[named_container_name]).to eq Container.containers[named_container_name]
          end

        end

        describe '#initialize' do

          it 'can create default container' do
            dc = default_container
            expect(Container.containers_count).to eq 1
            expect(Container.default_container).to eq dc
          end

          it 'default container name should be :default' do
            dc = default_container
            expect(Container[default_container_name]).to eq dc
          end

          it 'can create multiple containers' do
            dc = default_container
            nc = named_container
            expect(Container.containers_count).to eq 2
            expect(Container[default_container_name]).to eq dc
            expect(Container[named_container_name]).to eq nc
          end

          it 'should raise error when container with the same name exists' do
            Container.new
            expect { Container.new }.to raise_error(DuplicateContainerError)
          end

        end

        describe '#reset' do

          it 'should have no containers after reset' do
            dc = default_container
            expect(Container.default_container).to eq dc
            Container.reset
            expect(Container.containers_count).to eq 0
          end

        end


      end

      describe 'Instance Methods' do

        describe '#configure' do

          it 'should instance eval block' do
            dc = default_container

            dc.configure do
              register :a, 1
            end
            expect(dc.resolve(:a)).to eq 1
          end

        end

        describe '#register' do

          it 'can register objects' do
            dc = default_container
            dc.register :a, 1
            expect(dc.resolve :a).to eq 1
          end

          it 'can register procs' do
            dc = default_container
            dc.register :a do
              Object.new
            end

            o1 = dc.resolve :a
            o2 = dc.resolve :a

            expect(o1.is_a?(Object)).to be_truthy
            expect(o2.is_a?(Object)).to be_truthy
            expect(o1).not_to eq o2
          end

          it 'can use container in procs' do
            dc = default_container
            dc.register :a, lambda {|c| c}

            expect(dc.resolve :a).to eq dc
          end

          it 'ignores block when value is provided' do
            dc = default_container
            dc.register :a, 1 do
              2
            end
            expect(dc.resolve :a).to eq 1
          end

          it 'can register named dependency' do
            dc = default_container
            dc.register :a, 1, name: :one
            expect(dc.resolve(:a, name: :one)).to eq 1
          end

        end

        describe '#resolve' do

          it 'can resolve dependency' do
            dc = default_container
            dc.register :a, 1
            expect(dc.resolve :a).to eq 1
          end

          it 'can resolve named dependency' do
            dc = default_container
            dc.register :a, 1, name: :one
            expect(dc.resolve(:a, name: :one)).to eq 1
          end

          it 'should raise error when dependency not found' do
            dc = default_container
            expect { dc.resolve(:a) }.to raise_error(ResolutionError)
          end

          it 'should raise error when named dependency not found' do
            dc = default_container
            dc.register :a, 1
            expect { dc.resolve(:a, name: :one) }.to raise_error(ResolutionError)
          end

        end

        describe '#resolve_all' do

          it 'can resolve dependency with multiple registrations' do
            dc = default_container
            dc.register :a, 1
            dc.register :a, 2, name: :other
            expect(dc.resolve_all :a).to eq [1, 2]
          end

          it 'should raise error when dependency not found' do
            dc = default_container
            expect { dc.resolve_all(:a) }.to raise_error(ResolutionError)
          end

        end

        describe '#clear' do

          it 'should clear all registrations' do
            dc = default_container
            dc.register :a, 1
            expect(dc.registry_map.size).to eq 1
            dc.clear
            expect(dc.registry_map.size).to eq 0
          end

        end

      end



    end

  end
end
