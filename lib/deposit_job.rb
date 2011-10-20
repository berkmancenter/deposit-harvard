class DepositJob < Struct.new(:deposit_request_id, :repository)
  def perform
    depo = Deposit.repositories[repository]
    Rails.logger.info("Found depo: #{depo}")
    repo = depo.repository
    Rails.logger.info("Found repo: #{repo}")

    dr = DepositRequest.find(deposit_request_id)

    # Default to METS for now; later we'll add ways to specify
    # or infer other packaging schemes and other repositories.
    tmp_file = Tempfile.new(['archive-', '.foo'], File.join(Rails.root, "tmp"))
    tmp_name = tmp_file.path.gsub!(/.foo$/, "-#{rand(10101)}.zip")
    m = Deposit::Packagers::Mets.new :sac_file_out => tmp_name

    ['title', 'abstract', 'status_statement', 'language', 'custodian', 'identifier', 'copyright_holder'].each do |attr|
      if val = dr.send(attr.to_sym)
        m.send("sac_#{attr}=".to_sym, val)
      end
    end

    m.sac_date_available = dr.date_available.strftime("%Y-%m-%dT%H:%M:%S") unless dr.date_available.blank?

    # Authors can be a YAMLized array or a single author string.
    [YAML::load(dr.authors)].flatten.each do |author|
      m.add_creator(author)
    end

    dr.attachments.each do |attachment|
      filename = attachment.file.current_path
      m.add_file filename, MIME::Types.type_for(filename).first.content_type
    end

    m.create_archive

    Rails.logger.info("Pushing archive #{m.archive_filename} to DepositURL #{repo.default_collection.deposit_url}")

    depo.post_file(m.archive_filename, repo.default_collection.deposit_url)

    tmp_file.unlink
    m.clean_up_files!
  end
end
