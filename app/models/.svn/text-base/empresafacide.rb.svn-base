class Empresafacide < ActiveRecord::Base
  
  private
    def validate
      if(nome == nil || nome == "")
        errors.add("campo[nome]", "O campo NOME tem que ser preenchido")
      else
        values = Empresafacide.find_all_by_nome(nome);
        if(values.length > 0)
          errors.add("campo[nome]", "J‡ existe uma empresa com o mesmo NOME")
        end
      end
      if((email == nil || email == "") && (telefone == nil || telefone == "") && (fax == nil || fax == "")) 
        errors.add("campo[email]", "Tem que ser preenchido um CONTACTO da empresa (EMAIL ou TELEFONE)")
      end
    end
  
end
