class EventoController < ApplicationController
  
  def novo
    @entidade = Entidade.find_by_sigla(params[:entidade])
    
    ## Cria Evento com campos b‡sicos
    @evento = Evento.new()
    if(params[:nome] != nil)
      @evento.nome = params[:nome]
      @evento.nome_curto = params[:nome_curto]
      @evento.descricao = params[:descricao]
      @evento.entidade = Entidade.find_by_sigla(params[:entidade])
      @evento.data_inicio = params[:data_inicio]
      @evento.data_fim = params[:data_fim]
      @evento.codigo = params[:codigo]
      
      #defaults
      @evento.inscricoes_abertas = false
      @evento.publico = false
      @evento.activo = true
      
      @evento.save()
    end
  end
  
  def update
    evento = Evento.find_by_codigo(params[:event])
    
    params[:event_fields].each do |event_field|
      eval("evento."+event_field[0]+" = "+event_field[1])
    end
    
    evento.save()
  end
  
  
  def toggle_evento_activo
    evento = Evento.find_by_codigo(params[:event])
    if(evento.activo)
      evento.activo = false
    else
      evento.activo = true
    end
    evento.save()
  end
  
  
  def toggle_evento_inscricoes_abertas
    evento = Evento.find_by_codigo(params[:event])
    if(evento.activo)
      evento.inscricoes_abertas = false
    else
      evento.inscricoes_abertas = true
    end
    evento.save()
  end
  
  
  def toggle_evento_publico
    evento = Evento.find_by_codigo(params[:event])
    if(evento.publico)
      evento.publico = false
    else
      evento.publico = true
    end
    evento.save()
  end
  
  
  
  
  def add_grupo_campos
    
  end
  
  def update_grupo_campos
    
  end
  
  def get_grupos_campos
    
  end
  
  
  
  
  def add_campo
    
  end
  
  def update_campo
  
  end
  
  def get_campos
    
  end
  
  
  
  
  def add_lista_valores
    
  end
  
  def update_lista_valores
    
  end
  
  def get_lista_valores
    
  end
  
  
  
  
  def add_valor_to_lista
    
  end
  
  def update_valor
    
  end
  
  def get_valores
    
  end
  
end
