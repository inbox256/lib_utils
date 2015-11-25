  # s3 connection v2 style
  #
  def s3_connection()
    # log "#{__method__} #{ENV['AWS_ACCESS_KEY_ID']} ::: #{ENV['AWS_SECRET_ACCESS_KEY']}"

    client = Aws::S3::Client.new(
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
        :region => 'us-west-1')

    resource = Aws::S3::Resource.new(client: client)

    resource
  end

  def s3_bucket(bucketName)
    resource = s3_connection()
    resource.bucket(bucketName)
  end

  # Write to s3
  #
  def s3_upload(bucketName, prefix, filename, file)
    log("create s3 object #{prefix}/#{filename}")

    s3object = s3_bucket(bucketName).object("#{prefix}/#{filename}")

    log("s3object: #{s3object.to_s}")

    url = URI.parse(s3object.presigned_url(:put, acl: 'public-read'))
    log("url #{url}")

    body = File.read(file)

    Net::HTTP.start(url.host) do |http|
      http.send_request("PUT", url.request_uri, body, {
                                 "content-type" => "" # This is required, or Net::HTTP will add a default unsigned content-type.
                             })
    end

    log("finished")

    url.to_s.split("?")[0]
  end