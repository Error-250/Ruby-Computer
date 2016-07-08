# Memory 主存
require './Device.rb'

class Memory < Device
  def initialize dbus, abus, cbus
    super dbus, abus, cbus
    @data = Array.new(128, 0) # 存储空间为128 * 8位 地址为00000000 - 01111111
  end
  
  def work # 激活
    if @rw == 1 # 写数据
      @data[@addr.to_i(2)] = @in_data
      @rw = 0 # 数据保护
    else
      @dbus.setData Addr_Device[:CPU] + @data[@addr.to_i(2)] # 返回数据
    end
  end
end
# Ready