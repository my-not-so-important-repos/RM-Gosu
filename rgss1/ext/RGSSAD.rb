module RGSSAD

  @@files = []
  @@xor = 0xDEADCAFE
  ENC_FILE = Dir["Game.rgss{ad,2a}"][0] || ""
  RGSSAD_File = Struct.new('RGSSAD_File', :filename, :filename_size, :file, :file_size)

  public

  def self.decrypt
    return unless File.exists?(ENC_FILE)
    @@files.clear
    rgssad = ''
    File.open(ENC_FILE, 'rb') {|file|
      file.read(8)
      rgssad = file.read
    }
    rgssad = self.parse_rgssad(rgssad, true)
    offset = 0
    while rgssad[offset] != nil
      file = RGSSAD_File.new
      file.filename_size = rgssad[offset, 4].unpack('L')[0]
      offset += 4
      file.filename = rgssad[offset, file.filename_size]
      offset += file.filename_size
      file.file_size = rgssad[offset, 4].unpack('L')[0]
      offset += 4
      file.file = rgssad[offset, file.file_size]
      @@files << file
      offset += file.file_size
    end
  end
  
  def self.files
    @@files
  end

  def self.add_file(file_contents, filename)
    file = RGSSAD_File.new
    file.filename = filename
    file.filename_size = filename.size
    file.file = file_contents
    file.file_size = file_contents.size
    @@files.delete_if {|f| f.filename == file.filename}
    @@files << file
    @@files.sort! {|a,b| a.filename <=> b.filename}
  end

  def self.encrypt
    return if @@files.empty? && !File.exists?(ENC_FILE)
    rgssad = ''
    @@files.each do |file|
      rgssad << [file.filename_size].pack('L')
      rgssad << file.filename
      rgssad << [file.file_size].pack('L')
      rgssad << file.file
    end
    File.open(ENC_FILE, 'wb') do |file|
      file.print("RGSSAD\0\1")
      file.print(self.parse_rgssad(rgssad, false))
    end
  end

  private

  def self.next_key
    @@xor = (@@xor * 7 + 3) & 0xFFFFFFFF
  end
  
  def self.parse_rgssad(string, decrypt)
    @@xor = 0xDEADCAFE
    new_string = ''
    offset = 0
    remember_offsets = []
    remember_keys = []
    remember_size = []
    while string[offset] != nil
      namesize = string[offset, 4].unpack('L')[0]
      new_string << [namesize ^ @@xor].pack('L')
      namesize ^= @@xor if decrypt
      offset += 4
      self.next_key
      filename = string[offset, namesize]
      namesize.times do |i|
        filename.setbyte(i, filename.getbyte(i) ^ @@xor & 0xFF)
        self.next_key
      end
      new_string << filename
      offset += namesize
      datasize = string[offset, 4].unpack('L')[0]
      new_string << [datasize ^ @@xor].pack('L')
      datasize ^= @@xor if decrypt
      remember_size << datasize
      offset += 4
      self.next_key
      data = string[offset, datasize]
      new_string << data
      remember_offsets << offset
      remember_keys << @@xor
      offset += datasize
    end
    remember_offsets.size.times do |i|
      offset = remember_offsets[i]
      @@xor = remember_keys[i]
      size = remember_size[i]
      data = new_string[offset, size]
      data = data.ljust(size + (4 - size % 4)) if size % 4 != 0
      s = ''
      data.unpack('L' * (data.size / 4)).each do |j|
        s << ([j ^ @@xor].pack('L'))
        self.next_key
      end
      new_string[offset, size] = s.slice(0, size)
    end
    return new_string
  end
end