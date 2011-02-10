class ConsumosController < ApplicationController
  
  def consumos_recibo
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    recibo = Recibo.find_by_id(params[:id])
    
    @consumos = recibo.consumos
    
    @consumos_por_inscricao = []
    @inscricoes = []
    @consumos.each do |consumo|
      if(@consumos_por_inscricao[consumo.inscricao_id] == nil)
        @inscricoes << consumo.inscricao
        @consumos_por_inscricao[consumo.inscricao_id] = []
      end
      @consumos_por_inscricao[consumo.inscricao_id] << consumo
    end
    
  end
  
end
