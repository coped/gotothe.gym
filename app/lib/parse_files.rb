module ParseFiles
    def files_in(directory)
        Dir.children(directory)
    end

    def find_json_file(files)
        files.find { |file| file.include?(".json") }
    end

    def file_contents(file)
        File.read(file)
    end
end
