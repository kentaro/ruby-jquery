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
        if arg.kind_of?(Proc)
          Lambda.new(arg)

        # `arg.kind_of?(Numeric)` isn't true.
        # Why not???
        elsif arg.kind_of?(Integer) || arg.kind_of?(Float)
          Numeric.new(arg)
        elsif arg.kind_of?(Symbol)
          Var.new(arg)
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
