class DepositJob < Struct.new(:deposit_request_id, :repository)
  def perform
    depo = Deposit.repositories[:repository]
    repo = depo.repository

    dr = DepositRequest.find(deposit_id)

    # Default to METS for now; later we'll add ways to specify
    # or infer other packaging schemes and other repositories.
    m = Deposit::Packagers::Mets.new :sac_file_out => Tempfile.new("archive.zip", File.join(Rails.root, "tmp")).path

    ['title', 'abstract', 'status_statement', 'language', 'custodian', 'identifier', 'copyright_holder'].each do |attr|
      if val = dr.send(attr.to_sym)
        m.send("sac_#{attr}=".to_sym, val)
      end
    end

    m.sac_date_available = dr.date_available.strftime("%Y-%m-%dT%H:%M:%S") unless dr.date_available.blank?

    YAML::load(dr.authors).each do |author|
      m.add_creator(author)
    end

    dr.attachments.each do |attachment|
      filename = attachment.file.current_path
      m.add_file filename, MIME::Types.type_for(filename).first.content_type
    end

    m.create_archive

    Logger.info("Pushing archive #{m.archive_filename} to DepositURL #{repo.default_collection.deposit_url}")

    depo.post_file(m.archive_filename, repo.default_collection.deposit_url)
    if false
      File.delete m.metadata_filename
      File.delete m.archive_filename
    end
  end
end
