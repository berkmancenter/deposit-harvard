module DepositRequestsHelper
  def document_type_options
    Metadata::TYPES
  end
  
  def status_statement_options
    Metadata::STATUS_STATEMENTS
  end
  
  def language_options
    Metadata::LANGUAGES
  end
end
