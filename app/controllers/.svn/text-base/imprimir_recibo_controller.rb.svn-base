class ImprimirReciboController < ApplicationController
  
  def recibo
    @recibo = Recibo.find_by_id(params[:id])
    @linhas_recibo = @recibo.linhas_recibo
    
    datamax = d = Date.new(2007, 1, 1)
    
    @recibo.pagamentos.each do |pagamento|
      if(pagamento.data > datamax)
        @recibo.data = pagamento.data
      end
    end
    
    
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "recibo", 
               :template => "imprimir_recibo/recibo.html.erb", 
               :stylesheets => ["recibo.css","print"],
               :layout => "imprimir_recibo.html.erb"
      end
    end
  end

  
end
