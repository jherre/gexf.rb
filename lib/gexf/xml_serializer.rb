class GEXF::XmlSerializer

  GEXF_ATTRS = {
    'xmlns' => "http://www.gephi.org/gexf",
    'xmlns:viz' => "http://www.gephi.org/gexf/viz",
  }

  def initialize(graph)
    @graph    = graph
    @document = nil
  end

  def serialize!
    document.to_xml
  end

private
  def g
    @graph
  end

  def graph_attributes
    # { :defaultedgetype   => g.defaultedgetype,
    #   :idtype            => g.idtype,
    #   :mode              => g.mode }
    { :type => "static" }
  end

  def build_attributes(xml)
    %w(nodes edges).each do |type|
      defined_attributes = g.send(type).defined_attributes
      next if defined_attributes.empty?

      xml.attributes(:class => type.gsub(/s$/,'')) {
        defined_attributes.map do |id, attr| 
          xml.attribute(attr.to_hash) {
            xml.default(attr.default) if attr.default
          }
        end
      }
    end
  end

  def build_nodes(xml)
    build_collection(xml, 'nodes')
  end

  def build_edges(xml)
    build_collection(xml, 'edges')
  end

  def build_collection(xml, collection_name, tagname=nil)
    tagname ||= collection_name.gsub /s$/,''

    xml.send(collection_name) do
      g.send(collection_name).each do |item|
        build_item(xml, item, tagname)
      end
    end
  end

  def build_item(xml, item, tagname)
    xml.send(tagname, item.to_hash) do
      if item.attr_values.any?
        xml.attvalues do
          item.attr_values.each do |id, value|
            value = value.join('|') if value.respond_to?(:join)
            xml.attvalue(:for => id, :value => value)
          end
        end
      end
      
      if item.viz_values.any?
        item.viz_values.each do |viz|
          xml.send(viz.tagname, viz.to_hash)
        end
      end
    end
  end

  def document
    @document ||= build do |xml|
      xml.gexf(GEXF_ATTRS) do
        xml.graph(graph_attributes) do
          build_attributes(xml) 
          build_nodes(xml)
          build_edges(xml)
        end
      end
    end
  end

  def build(&block)
    Nokogiri::XML::Builder.new(:encoding => 'UTF-8', &block)
  end
end
