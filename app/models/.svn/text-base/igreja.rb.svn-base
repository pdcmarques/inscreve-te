class Igreja < ActiveRecord::Base
    acts_as_authorizable
  
    has_many  :inscricaos
    has_one  :recibo
    has_many  :users
    
    #validates_presence_of   :nome
    #validates_presence_of   :responsavel
    #validates_presence_of   :email
    #validates_uniqueness_of :nome
    
    def numero_inscritos
      inscricaos.count
    end
    
    def total_recibos
      self.recibo.total_recibo
    end
    
    
    private
    def validate
      if(nome == nil || nome == "")
        errors.add("campo[nome]", "O campo NOME tem que ser preenchido")
      else
        values = Igreja.find_all_by_nome(nome);
        if(values.length > 0)
          errors.add("campo[nome]", "Já existe uma igreja com o mesmo nome")
        end
      end
      if(responsavel == nil || responsavel == "")
        errors.add("campo[responsavel]", "O campo RESPONSÁVEL tem que ser preenchido")
      end
      if((email == nil || email == "") && (telefone == nil || telefone == "")) 
        errors.add("campo[email]", "Tem que ser preenchido um contacto relativo ao responsável da igreja")
      end
    end
end
