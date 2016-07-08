# CBus 控制总线
require './Bus.rb'

class CBus < Bus
  
  def setData data # 传送控制信号
    data = decoder data
    @device[data[0]].getRW data[1]
  end
end
# Ready
