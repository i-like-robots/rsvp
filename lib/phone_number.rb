module PhoneNumber
  def self.normalize (val)
    # 1. remove all non-number chars
    # 2. assume leading zero means UK
    # 3. enforce preceeding +
    num = val.gsub(/[^\d]/, '').gsub(/\A0/, '44').gsub(/\A(\d)/, '+\0')
  end
end
