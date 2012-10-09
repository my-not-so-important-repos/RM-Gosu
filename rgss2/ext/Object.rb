class Object
  
  def load_data(filename)
    RGSSAD.files {|a|
      if a.filename == filename
        return Marshal.load(a)
      end
    }
    File.open(filename, "rb") { |f|
      Marshal.load(f)
    }
  end
  
  def save_data(obj, filename)
    if RGSSAD.files.size != 0
      RGSSAD.add_file(Marshal.dump(obj), filename)
    else
      File.open(filename, "wb") { |f|
        Marshal.dump(obj, f)
      }
    end
  end
end