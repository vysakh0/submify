module RandomAttribute

  def generate_unique_random_base64(attribute, n)
    until random_is_unique?(attribute)
      self.send(:"#{attribute}=", random_base64(n))
    end
  end

  def generate_unique_random_hex(attribute, n)
    until random_is_unique?(attribute)
      self.send(:"#{attribute}=", SecureRandom.hex(n/2))
    end
  end

  private

  def random_is_unique?(attribute)
    val = self.send(:"#{attribute}")
    val && !self.class.send(:"find_by_#{attribute}", val)
  end

  def random_base64(n)
    val = base64_url
    val += base64_url while val.length < n
    val.slice(0..(n-1))
  end

  def base64_url
    SecureRandom.base64(60).downcase.gsub(/\W/, '')
  end
end
