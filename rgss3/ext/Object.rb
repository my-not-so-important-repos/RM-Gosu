class Object
  
  def rgss_main(&block)
    begin
      block.call
    rescue RGSSReset
      retry
    end
  end
  
  def rgss_stop
    loop { Graphics.update }
  end
  
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
  
  def msgbox(*args)
  end
  
  def msgbox_p(*args)
  end
end