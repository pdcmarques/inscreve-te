class Chef
  class Recipe
    def eventmanager_edge?
      node[:eventmanager][:edge]
    end
  end
end