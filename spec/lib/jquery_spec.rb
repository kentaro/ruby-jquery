require_relative '../spec_helper'

module Kernel
  describe '#jQuery' do
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
        expect(jQuery(:document).to_s).to be == 'jQuery(document)'
      }
    end

    context 'when called with a integer argument' do
      it {
        expect(jQuery('a').text(1).to_s).to be == 'jQuery("a").text(1)'
      }
    end

    context 'when called with a float argument' do
      it {
        expect(jQuery("a").text(0.1).to_s).to be == 'jQuery("a").text(0.1)'
      }
    end

    context 'when called with an array argument' do
      it {
        expect(jQuery('a').foo(['a', 'b']).to_s).to be == 'jQuery("a").foo(["a","b"])'
      }
    end

    context 'when called with a hash argument' do
      it {
        expect(jQuery('a').foo({'a' => 'b'}).to_s).to be == 'jQuery("a").foo({"a":"b"})'
      }
    end

    context 'when called with a lambda' do
      it {
        expect(jQuery(->(f) { f.e 'return true' }).to_s).to be == 'jQuery(function (e) { return true })'
      }
    end

    context 'when called with method chain and various arguments' do
      it {
        expect(jQuery('#content').show().on('click', 'a', ->(f) { f.e 'return true' }).to_s).to be ==
          'jQuery("#content").show().on("click","a",function (e) { return true })'
      }
    end
  end
end

module JQuery
  describe Object do
    describe '.initialize' do
      context 'when no argument passed' do
        let(:obj) { JQuery::Object.new(:jQuery) }

        it {
          expect(obj).to be_an_instance_of(JQuery::Object)
          expect(obj.args.size).to be == 0
        }
      end

      context 'when an argument passed' do
        context 'and it is a String object' do
          let(:obj) { JQuery::Object.new(:jQuery, 'foo') }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSString)
          }
        end

        context 'and it is a Integer object' do
          let(:obj) { JQuery::Object.new(:jQuery, 1) }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSNumeric)
          }
        end

        context 'and it is a Float object' do
          let(:obj) { JQuery::Object.new(:jQuery, 0.1) }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSNumeric)
          }
        end

        context 'and it is a Symbol object' do
          let(:obj) { JQuery::Object.new(:jQuery, :document) }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSVar)
          }
        end

        context 'and it is an Array object' do
          let(:obj) { JQuery::Object.new(:jQuery, ['a', 'b']) }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSStruct)
          }
        end

        context 'and it is a Hash object' do
          let(:obj) { JQuery::Object.new(:jQuery, { 'a' => 'b' }) }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSStruct)
          }
        end

        context 'and it is a Proc object' do
          let(:obj) { JQuery::Object.new(:jQuery, ->() {}) }

          it {
            expect(obj).to be_an_instance_of(JQuery::Object)
            expect(obj.args.size).to be == 1
            expect(obj.args.first).to be_an_instance_of(JQuery::JSFunction)
          }
        end

        context 'and it is an unsupported object' do
          it {
            expect {
              JQuery::Object.new(:jQuery, Object.new)
            }.to raise_error(ArgumentError)
          }
        end
      end

      context 'when multiple argument passed' do
        let(:obj) { JQuery::Object.new(:jQuery, 'foo', 1) }

        it {
          expect(obj).to be_an_instance_of(JQuery::Object)
          expect(obj.args.size).to be == 2
          expect(obj.args[0]).to be_an_instance_of(JQuery::JSString)
          expect(obj.args[1]).to be_an_instance_of(JQuery::JSNumeric)
        }
      end
    end
  end

  describe JSString do
    describe '#to_s' do
      let(:obj) { JQuery::JSString.new('foo') }

      it {
        expect(obj.to_s).to be == %Q|"foo"|
      }
    end
  end

  describe JSNumeric do
    context 'when expr is an Integer' do
      describe '#to_s' do
        let(:obj) { JQuery::JSNumeric.new(1) }

        it {
          expect(obj.to_s).to be == 1
        }
      end
    end

    context 'when expr is a Float' do
      describe '#to_s' do
        let(:obj) { JQuery::JSNumeric.new(0.1) }

        it {
          expect(obj.to_s).to be == 0.1
        }
      end
    end
  end

  describe JSVar do
    describe '#to_s' do
      let(:obj) { JQuery::JSVar.new(:document) }

      it {
        expect(obj.to_s).to be == 'document'
      }
    end
  end

  describe JSStruct do
    context 'when expr is an Array' do
      describe '#to_s' do
        let(:obj) { JQuery::JSStruct.new(['a', 'b']) }

        it {
          expect(obj.to_s).to be == %Q|["a","b"]|
        }
      end
    end

    context 'when expr is a Hash' do
      describe '#to_s' do
        let(:obj) { JQuery::JSStruct.new({ 'a' => 'b' }) }

        it {
          expect(obj.to_s).to be == %Q|{"a":"b"}|
        }
      end
    end
  end

  describe JSFunction do
    describe '#to_s' do
      let(:obj) { JQuery::JSFunction.new(->(f) { f.e 'return true' }) }

      it {
        expect(obj.to_s).to be == 'function (e) { return true }'
      }
    end
  end
end