# This is a simple script that finds all files named as './config/environments/*' that do not end
# with '.local' and makes a new file for each by appending '.local' to the end of the file name.
module CreateLocalEnvironmentVariableFiles
  def self.create_files(relative_path)
    @relative_path = File.join(['.'] + relative_path)
    nonlocal_environment_files.each do |file|
      create_file("#{file}.local")
    end
  end

  def self.nonlocal_environment_files
    Dir.chdir(@relative_path)
    all_files = Dir.entries('.')
    all_files.find_all do |file|
      !file.end_with?('.local') && !['.', '..'].include?(file)
    end
  end

  def self.create_file(new_file)
    if File.exist?(new_file)
      puts "File '#{File.join(@relative_path, new_file)}' already exists."
    else
      `touch #{new_file}`
      verify_creation(new_file)
    end
  end

  def self.verify_creation(new_file)
    if File.exist?(new_file)
      puts "Created file: #{File.join(@relative_path, new_file)}"
    else
      puts "Could not automatically create file #{File.join(@relative_path, new_file)}, please " \
           'create manually'
    end
  end
end

CreateLocalEnvironmentVariableFiles.create_files(%w[config environments])
