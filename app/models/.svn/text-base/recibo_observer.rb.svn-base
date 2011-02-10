class ReciboObserver < ActiveRecord::Observer
  def after_save(recibo)
      tx_insc = recibo.taxa_inscricao
      pago = recibo.total_pago
      total = recibo.total_recibo-recibo.valor_desconto_antecipado
      recibo.consumos.each do |consumo|
      
      #refrescar os precos dos consumos
      consumo.preco = consumo.produto.get_preco(consumo.inscricao)
      consumo.save
      
      #refrescar o estado das reservas conforme o estado do pagamento
      if(tx_insc > 0 && pago >= tx_insc || pago >= total)
        inscricao_reservas = InscricaoReserva.find_all_by_consumo_id(consumo.id)
        inscricao_reservas.each do |inscricao_reserva|
          estado_actual = inscricao_reserva.reserva_estados[inscricao_reserva.reserva_estados.count-1]
          if(estado_actual.estado_reserva_id != 5 && estado_actual.estado_reserva_id != 3  && estado_actual.estado_reserva_id != 2 )
            estado_actual.data_fim = DateTime.now
            estado_actual.save
            estado = ReservaEstado.new
            estado.inscricao_reserva_id = inscricao_reserva.id
            estado.estado_reserva_id = 2
            estado.data_inicio = DateTime.now
            estado.save
          end
        end
      else
        if(recibo.nivel_alerta == 3)
          recibo.consumos.each do |consumo|
            inscricao_reservas = InscricaoReserva.find_all_by_consumo_id(consumo.id)
            inscricao_reservas.each do |inscricao_reserva|
              estado_actual = inscricao_reserva.reserva_estados[inscricao_reserva.reserva_estados.count-1]
              if(estado_actual.estado_reserva_id != 5 && estado_actual.estado_reserva_id != 3  && estado_actual.estado_reserva_id != 4)
                estado_actual.data_fim = DateTime.now
                estado_actual.save
                estado = ReservaEstado.new
                estado.inscricao_reserva_id = inscricao_reserva.id
                estado.estado_reserva_id = 4
                estado.data_inicio = DateTime.now
                estado.save
              end              
            end
          end
        else
          recibo.consumos.each do |consumo|
            inscricao_reservas = InscricaoReserva.find_all_by_consumo_id(consumo.id)
            inscricao_reservas.each do |inscricao_reserva|
              estado_actual = inscricao_reserva.reserva_estados[inscricao_reserva.reserva_estados.count-1]
              if(estado_actual.estado_reserva_id != 5 && estado_actual.estado_reserva_id != 3  && estado_actual.estado_reserva_id != 1)
                estado_actual.data_fim = DateTime.now
                estado_actual.save
                estado = ReservaEstado.new
                estado.inscricao_reserva_id = inscricao_reserva.id
                estado.estado_reserva_id = 1
                estado.data_inicio = DateTime.now
                estado.save
              end
            end
          end
        end
      end
    end
  end
end
