class Object
  
  def load_data(filename)
    File.open(filename, "rb") { |f|
      Marshal.load(f)
    }
  end
  
  def save_data(obj, filename)
    File.open(filename, "wb") { |f|
      Marshal.dump(obj, f)
    }
  end
end