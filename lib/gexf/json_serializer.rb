require 'json'

class GEXF::JsonSerializer
  
  def initialize(graph)
    @graph    = graph
  end

  def serialize!
    JSON.pretty_unparse document
  end
  
  private
  
  def nodes
    @nodes ||= @graph.nodes.values
  end
  
  def document
    {
      'nodes' => build_nodes,
      'links' => build_links,
    }
  end
  
  def build_nodes
    nodes.map{ |node|
      h = {'label' => node.label}
      h.update(node.attributes)
    }
  end
  
  def build_links
    @graph.edges.map{ |edge|
      h = {
        'source' => nodes.index(edge.source),
        'target' => nodes.index(edge.target),
        'weight' => edge.weight,
      }
      h.update(edge.attributes)
    }
  end
  
end
