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
  
  def render_jobs(deposit_request)
    html = "<table id='jobs-table'>"
    completed_repositories = deposit_request.repositories.dup

    deposit_request.jobs.each do |job|
      handler = YAML.load(job.handler)
      html << "<tr><td>"
      
      if job.failed?
        html << "F"
      else
        html << "P"
      end
    
      html << "</td><td>"
      
      completed_repositories.delete(handler.repository)
      html << Deposit.repositories[handler.repository.to_sym].config['name']
      html << "</td></tr>"
    end
    
    html << "</table><table id='completed-jobs-table'>"
    
    completed_repositories.each do |completed|
      html << "<tr><td>C</td><td>"
      html << Deposit.repositories[completed.to_sym].config['name']
      html << "</td></tr>"
    end
    
    html << "</table>"
    
    html.html_safe
  end
end
