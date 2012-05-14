module SanitizerLocation
   def sanitize(size, unit)
    
    num = 0
    precision = 1
    modulo = size
    
    while modulo < 0.999999999999
      modulo = modulo * 10
      precision = precision * 10
      num += 1
    end

    unit = unit.round(num)
    modulo = (size * precision).round
    return (unit - (((unit*precision).round)%modulo).to_f / precision).round(num)
    
  end


   extend self
end
