# Cpu_Bus CPU内部总线
require './Bus.rb'
class Cpu_Bus < Bus
  
  def decoder data # 解析数据
    rel = []
    rel << data[0]
    rel << data[1..Add_Size-1]
    rel << data[Add_Size..data.size]
  end
  
  def setData data # 传送数据
    data = decoder data
    case data[1].to_i(2)
    when 0 then @device[data[0].to_i].getData data[2]
    when 1 then @device[data[0].to_i].getAddr data[2]
    when 2 then @device[data[0].to_i].getRW data[2]
    end
  end
end