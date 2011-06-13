class Chef
  class Recipe
    def radiant_edge?
      node[:eventmanager][:edge]
    end
  end
end