class EventosController < ApplicationController
  
  
  def list
    @entidade = Entidade.find_by_sigla(params[:entidade])
    todos_eventos = @entidade.eventos
    @eventos = []
    todos_eventos.each do |evento|
      if(evento.publico && evento.activo)
        @eventos << evento
      end
    end
    
    render :template=>"eventos/list.xml.erb", :layout=>false
  end
  
end
