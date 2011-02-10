module StringTranslator
  module Acts
    module Translatable
      
      def self.included(base)
        # add all methods from the module "AddActsAsMethod" to the 'base' module
        base.extend AddActsAsMethod
      end
      module AddActsAsMethod
        def acts_as_translatable(opts)
          # BELONGS_TO HAS_MANY GOES HERE

          #self.extend(ClassMethods)
          self.send :include, StringTranslator
          
          opts[:attributes].each do |atribute|
            define_method(atribute) do
              super_value = super();
              translate(super_value)
            end
          end

          #class_eval <<-END
          #  include YourSuperName::Acts::Translatable::InstanceMethods
          #END
        end
      end
      
    end
  end
  
  def translate(string_key)
    
    #puts "**********************   TRANSLATING: '"+string_key + "' with locale '"+current_locale+"'   **********************"
    
    if(string_key.starts_with? 'i18n:')
      translation = Translation.find_by_codigo_locale(current_locale, :conditions => "string_code = '"+string_key[5..string_key.size]+"'")
      if(translation != nil)
        return translation.string_value
      else
        translation = Translation.find_by_codigo_locale('pt_PT', :conditions => "string_code = '"+string_key[5..string_key.size]+"'")
        if(translation != nil)
          return translation.string_value
        else 
          return string_key[5..string_key.size]
        end
      end
    else
      return string_key
    end
  end
  
  
  def current_locale
    Thread.current[:locale]
  end
 
  def self.current_locale=(locale)
    Thread.current[:locale] = locale
  end
    
  
end

