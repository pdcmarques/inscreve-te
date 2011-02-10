class Igrejamg < ActiveRecord::Base
  
  private
    def validate
      if(nome == nil || nome == "")
        errors.add("campo[nome]", "O campo NOME tem que ser preenchido")
      else
        values = Igreja.find_all_by_nome(nome);
        if(values.length > 0)
          errors.add("campo[nome]", "Já existe uma igreja com o mesmo NOME")
        end
      end
      if(codigo_postal == nil || codigo_postal == "")
        errors.add("campo[codigo_postal]", "O campo CÓDIGO POSTAL tem que ser preenchido")
      end
      if(codigo_postal.length != 8 || codigo_postal[4,1] != "-" || codigo_postal[5,3] == "000" || codigo_postal[5,3] == "999")
        logger.error "LENGTH: "+codigo_postal.length.to_s
        logger.error "4,1   : "+codigo_postal[4,1].to_s
        logger.error "5,7   : "+codigo_postal[5,3].to_s
        errors.add("campo[codigo_postal]", "O CÓDIGO POSTAL tem que estar num formato XXXX-XXX válido")
      end
      if((email == nil || email == "") && (telefone == nil || telefone == "") && (fax == nil || fax == "")) 
        errors.add("campo[email]", "Tem que ser preenchido um CONTACTO da igreja (EMAIL, TELEFONE ou FAX)")
      end
    end
  
end
