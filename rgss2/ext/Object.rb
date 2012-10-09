class Object
  
  def load_file(filename)
    File.open(filename, "rb") { |f|
      Marshal.load(f)
    }
  end
  
  def save_file(obj, filename)
    File.open(filename, "wb") { |f|
      Marshal.dump(obj, f)
    }
  end
end