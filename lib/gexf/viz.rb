class GEXF::Viz
  
  class MissingAttributes < StandardError; end
  
  attr_reader :tag, :attributes
  
  def initialize(tag, opts={})
    @tag = tag
    @attributes = opts
    case @tag
    when :color
      require_opts(:r, :g, :b)
    when :size
      require_opts(:value)
    else
      raise MissingAttributes, @tag
    end
  end
  
  def tagname
    "viz:#{tag}"
  end
  
  def to_hash
    @attributes
  end
  
  private
  
  def require_opts(*needed)
    missing = needed - @attributes.keys
    raise MissingAttributes, missing.inspect unless missing.empty?
  end
  
end

module GEXF::Viz::Assignable
  
  def viz_values
    @viz_values ||= []
  end
  
  def viz(tag, opts={})
    viz_values << GEXF::Viz.new(tag, opts)
  end
  
end
