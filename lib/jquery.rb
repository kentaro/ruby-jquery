require "json"
require "jquery/version"

module Kernel
  def jQuery(*args)
    JQuery::Object.new(:jQuery, *args)
  end
end

module JQuery
  class Object
    attr_accessor :label, :args, :prev, :next

    def initialize(label, *args)
      @label = label.to_s
      @args  = args.map do |arg|
        case arg
        when String
          JSString.new(arg)
        when Numeric
          JSNumeric.new(arg)
        when Symbol
          JSVar.new(arg)
        when Array, Hash
          JSStruct.new(arg)
        when Proc
          JSFunction.new(arg)
        else
          raise ArgumentError.new("#{arg.class} is not supported")
        end
      end
    end

    def to_s
      current = self
      chain   = [current]

      while current.prev
        current = current.prev
        chain.unshift(current)
      end

      result = []
      chain.map do |obj|
        expr = ''
        expr << "#{obj.label}("
        expr << obj.args.map { |arg| arg.to_s }.join(',')
        expr << ')'
        result << expr
      end

      result.join('.')
    end

    def method_missing(method, *args)
      next_obj    = self.class.new(method, *args)
      self.next   = next_obj
      next_obj.prev = self
      next_obj
    end
  end

  class JSExpr
    attr_accessor :expr

    def initialize(expr)
      @expr = expr
    end
  end

  class JSString < JSExpr
    def to_s
      %Q|"#{expr}"|
    end
  end

  class JSNumeric < JSExpr
    def to_s
      expr
    end
  end

  class JSVar < JSExpr
    def to_s
      expr.to_s
    end
  end

  class JSStruct < JSExpr
    def to_s
      JSON.dump(expr)
    end
  end

  class JSFunction < JSExpr
    # XXX
    def to_s
      'function () {}'
    end
  end
end
