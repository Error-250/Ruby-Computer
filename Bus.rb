# Bus 总线
require './common.rb'
class Bus < Common_Meta
  def initialize
    @device = [] # 接入设备集合
  end
  
  def decoder data # 解析数据
    rel = []
    rel << data[0..Add_Size-1].to_i(2)
    rel << data[Add_Size..data.size]
    rel
  end
  # TODO alias << add
  def << device # 接入设备
    add device
    self
  end
  
  def add *device # 接入设备
    device.each do |d|
      @device << d
    end
  end
end
# Ready
