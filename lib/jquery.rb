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
        when ::Proc
          Lambda.new(arg)
        when ::Numeric
          Numeric.new(arg)
        when ::Symbol
          Var.new(arg)
        when ::Hash, ::Array
          Struct.new(arg)
        else
          String.new(arg)
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

  class String
    attr_accessor :expr

    def initialize(expr)
      @expr = expr
    end

    def to_s
      %Q|"#{expr}"|
    end
  end

  class Numeric
    attr_accessor :expr

    def initialize(expr)
      @expr = expr
    end

    def to_s
      expr
    end
  end

  class Var
    attr_accessor :expr

    def initialize(expr)
      @expr = expr
    end

    def to_s
      expr.to_s
    end
  end

  class Struct
    attr_accessor :expr

    def initialize(expr)
      @expr = expr
    end

    def to_s
      JSON.dump(expr)
    end
  end

  class Lambda
    attr_accessor :expr

    def initialize(expr)
      @expr = expr
    end

    # XXX
    def to_s
      'function () {}'
    end
  end
end
