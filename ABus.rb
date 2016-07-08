# ABus 地址总线
require './Bus.rb'

class ABus < Bus
  
  def setData data # 传送地址
    data = decoder data
    @device[data[0]].getAddr data[1]
  end
end
# Ready