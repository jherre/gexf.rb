class GEXF::EdgeSet < GEXF::SetOfSets
  def <<(edge)
    append_to_key(edge.source_id, edge)
    append_to_key(edge.target_id, edge) unless edge.directed?
    self
  end
  
  def contain?(node_id)
    @hash.has_key?(node_id)
  end
end
