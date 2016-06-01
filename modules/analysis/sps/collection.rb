
class Collection
  attr_accessor :collection_name
  
  def initalize(collection_name)
    @collection_name = collection_name
  end

  def get_doc(query)
  end

  def add_doc(query)
  end

  def update_doc(query)
  end

  def delete_doc(query)
  end

  def is_in_db?(query)
  end
end
