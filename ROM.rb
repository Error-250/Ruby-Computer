# ROM 只读存储器
require './Device.rb'

class ROM < Device
  def initialize dbus, abus, cbus
    super dbus, abus, cbus
    @rw = 0 # 控制信息永远为读
    @data = Array.new(128, 0) # 存储空间为128 * 8位 地址为10000000 - 11111111
    @data[0] = OpCode[:Lad] # 预存储信息
    @data[1] = "00000000"
    @data[2] = OpCode[:Jmp]
    @data[3] = "00000000"
    @data[4] = OpCode[:Hlt]
  end
  
  def work # 激活
    addr = @addr[1..@addr.size].to_i(2)
    @dbus.setData Addr_Device[:CPU] + @data[addr]
  end
  
  def getData data;end
  def getRW data
    work
  end
end
# Ready