require 'spec_helper'

module Af
  describe Ioc do

    it 'should auth create default container on register' do
      Ioc.register(:a, 1)
      expect(Ioc::Container.containers_count).to eq 1
    end

    describe 'delegation' do

      it 'should delegate configure to Container' do
        expect(Ioc::Container).to receive(:configure)
        Ioc.configure
      end

      it 'should delegate register to Container' do
        expect(Ioc::Container).to receive(:register).with(:a, 1)
        Ioc.register(:a, 1)
      end

      it 'should delegate resolve to Container' do
        expect(Ioc::Container).to receive(:resolve).with(:a)
        Ioc.resolve(:a)
      end

      it 'should delegate resolve all to Container' do
        expect(Ioc::Container).to receive(:resolve_all).with(:a)
        Ioc.resolve_all(:a)
      end

      it 'should delegate clear to Container' do
        expect(Ioc::Container).to receive(:clear)
        Ioc.clear
      end

      it 'should delegate reset to Container' do
        expect(Ioc::Container).to receive(:reset)
        Ioc.reset
      end

    end

  end
end