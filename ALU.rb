# ALU 运算器
require './Device.rb'

class ALU < Device
  
  def initialize dbus, abus, cbus
    super dbus, abus, cbus
    @register = Array.new(2,0) # x , y
  end
  
  def work # 激活
    data = "00000000"
    case @rw
    when 0 then data = add @register[0], @register[1] # add
    when 1 then @register[@addr.to_i(2)] = @in_data   # 输入数据
    when 2 then data = left @register[0] # Lef
    when 3 then data = right @register[0] # Rit
    end
    @dbus.setData CPU_Addr_Device[:Control] + data
  end
  
  def add x, y # 算术加
    encode (x.to_i(2) + y.to_i(2))
  end
  
  def left x
    x = x.to_i(2)
    x = x << 1
    encode x
  end
  
  def right x
    x = x.to_i(2)
    x = x >> 1
    encode x
  end
end
# Ready
# TODO 其他运算器功能