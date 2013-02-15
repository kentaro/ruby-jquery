require 'spec_helper'

describe JQuery do
  describe '#to_s' do
    context 'when called with no argument' do
      it {
        expect(jQuery().to_s).to be == 'jQuery()'
      }
    end

    context 'when called with a string argument' do
      it {
        expect(jQuery('a').to_s).to be == 'jQuery("a")'
      }
    end

    context 'when called with a symbol argument' do
      it {
        expect(jQuery(:'document').to_s).to be == 'jQuery(document)'
      }
    end

    context 'when called with a integer argument' do
      it {
        expect(jQuery(1).to_s).to be == 'jQuery(1)'
      }
    end

    context 'when called with a float argument' do
      it {
        expect(jQuery(0.1).to_s).to be == 'jQuery(0.1)'
      }
    end

    context 'when called with an array argument' do
      it {
        expect(jQuery(['a', 'b']).to_s).to be == 'jQuery(["a","b"])'
      }
    end

    context 'when called with a hash argument' do
      it {
        expect(jQuery({'a' => 'b'}).to_s).to be == 'jQuery({"a":"b"})'
      }
    end

    context 'when called with a lambda' do
      it {
        expect(jQuery(->() {}).to_s).to be == 'jQuery(function () {})'
      }
    end

    context 'when called with method chain' do
      it {
        expect(jQuery('a').text().to_s).to be == 'jQuery("a").text()'
      }
    end
  end
end
