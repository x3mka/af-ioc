require 'spec_helper'

module Af
  module Ioc

    shared_examples 'a container_item' do
      it 'stores container' do
        expect(container_item.container).to eq(container)
      end

      it 'stores item key - value pair' do
        expect(container_item.key).to eq(container_item_key)
        expect(container_item.value).to eq(container_item_value)
      end

      it 'returns instance for item' do
        expect(container_item.instance).to eq(container_item_instance)
      end
    end

    describe ContainerItem do

      let(:container) { double() }
      let(:container_item_key) { :key }
      let(:container_item_value) { 'value' }
      let(:container_item_instance) { 'value' }
      let(:container_item) { ContainerItem.new(container, container_item_key, container_item_value) }

      context 'without proc' do
        it_behaves_like "a container_item"
      end

      context 'with proc' do

        context 'without argument' do
          let(:container_item_value) {
            Proc.new do
              'value'
            end
          }

          it_behaves_like 'a container_item'
        end

        context 'with argument' do
          let(:container_item_value) {
            Proc.new do |c|
              expect(c).to eq(container)
              'value'
            end
          }

          it_behaves_like 'a container_item'
        end

      end

    end

  end
end
