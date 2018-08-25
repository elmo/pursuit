class FalconSftp
  attr_accessor :host
  attr_accessor :username
  attr_accessor :password

  def initialize(host,username,password)
    @host = host
    @username = username
    @password = password
  end

  def upload(local_path:, remote_path: )
    Net::SFTP.start(host, username, password: password) do |sftp|
      sftp.upload!(local_path,remote_path)
    end
  end

  def download(remote_path: )
    data = nil
    Net::SFTP.start(host, username, password: password) do |sftp|
      data = sftp.download!(remote_path)
    end
    data
  end

  def write_data(remote_path:)
    Net::SFTP.start(host, username, password: password) do |sftp|
      sftp.file.open(remote_path, "w" ) do |f|
        f.puts "Hello, world!\n"
      end
    end
  end

  def read_data(remote_path:)
    data = []
    Net::SFTP.start(host, username, password: password) do |sftp|
       sftp.file.open(remote_path, "r") do |f|
         data << f.gets
       end
    end
    data
  end

   def make_remote_directory(directory_path:)
     Net::SFTP.start(host, username, password: password) do |sftp|
       sftp.mkdir! directory_path
     end
   end

   def read_remote_directory(directory_path:)
     entries = []
     Net::SFTP.start(host, username, password: password) do |sftp|
       sftp.dir.foreach(directory_path) do |entry|
         entries << entry.name
       end
     end
     entries
   end

end
