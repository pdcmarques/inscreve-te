class ProdutosController < ApplicationController
  
  def lista
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @produtos = Produto.find_all_by_entidade_id(@entidade.id, :conditions=>"evento_id is null OR (evento_id is not null and evento_id = "+@event.id.to_s+")")
  end
  
end
